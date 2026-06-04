{ ... }:
{
  flake.nixosModules.plasma-manager =
    {
      config,
      lib,
      pkgs,
      username,
      ...
    }:
    let
      ultrawideWindows = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "kwin-script-ultrawide-windows";
        version = "5.0";

        src = pkgs.fetchFromGitHub {
          owner = "lucmos";
          repo = "UltrawideWindows";
          rev = finalAttrs.version;
          hash = "sha256-9Ku/3OisXtV7KExPEfgJOWwDakqw1OsLZrgS91LNBAA=";
        };

        nativeBuildInputs = [ pkgs.kdePackages.kpackage ];
        buildInputs = [ pkgs.kdePackages.kwin ];

        dontBuild = true;
        dontWrapQtApps = true;

        installPhase = ''
          runHook preInstall

          kpackagetool6 --type KWin/Script --install $src --packageroot $out/share/kwin/scripts

          runHook postInstall
        '';

        meta = {
          description = "KWin script to move windows quickly on ultrawide monitors";
          homepage = "https://github.com/lucmos/UltrawideWindows";
          license = lib.licenses.gpl2Only;
          platforms = lib.platforms.linux;
        };
      });
      mediaPlaybackInhibit = pkgs.writeShellScript "media-playback-inhibit" ''
        set -eu

        inhibit_pid=
        screensaver_cookie=

        cleanup() {
          if [ -n "''${screensaver_cookie:-}" ]; then
            ${pkgs.glib}/bin/gdbus call --session \
              --dest org.freedesktop.ScreenSaver \
              --object-path /ScreenSaver \
              --method org.freedesktop.ScreenSaver.UnInhibit \
              "$screensaver_cookie" >/dev/null 2>&1 || true
          fi

          if [ -n "''${inhibit_pid:-}" ]; then
            kill "$inhibit_pid" >/dev/null 2>&1 || true
            wait "$inhibit_pid" >/dev/null 2>&1 || true
          fi
        }

        trap cleanup EXIT INT TERM

        is_playing() {
          ${pkgs.playerctl}/bin/playerctl --all-players status 2>/dev/null | ${pkgs.gnugrep}/bin/grep -qx Playing
        }

        inhibit_screensaver() {
          ${pkgs.glib}/bin/gdbus call --session \
            --dest org.freedesktop.ScreenSaver \
            --object-path /ScreenSaver \
            --method org.freedesktop.ScreenSaver.Inhibit \
            media-playback-inhibit "Media is playing" 2>/dev/null \
            | ${pkgs.gnused}/bin/sed -n 's/.*uint32 \([0-9]\+\).*/\1/p'
        }

        while true; do
          if is_playing; then
            if [ -z "''${inhibit_pid:-}" ] || ! kill -0 "$inhibit_pid" >/dev/null 2>&1; then
              ${pkgs.systemd}/bin/systemd-inhibit \
                --what=sleep:idle \
                --mode=block \
                --who=media-playback-inhibit \
                --why="Media is playing" \
                ${pkgs.coreutils}/bin/sleep infinity &
              inhibit_pid=$!
            fi

            if [ -z "''${screensaver_cookie:-}" ]; then
              screensaver_cookie="$(inhibit_screensaver || true)"
            fi
          else
            if [ -n "''${screensaver_cookie:-}" ]; then
              ${pkgs.glib}/bin/gdbus call --session \
                --dest org.freedesktop.ScreenSaver \
                --object-path /ScreenSaver \
                --method org.freedesktop.ScreenSaver.UnInhibit \
                "$screensaver_cookie" >/dev/null 2>&1 || true
              screensaver_cookie=
            fi

            if [ -n "''${inhibit_pid:-}" ]; then
              kill "$inhibit_pid" >/dev/null 2>&1 || true
              wait "$inhibit_pid" >/dev/null 2>&1 || true
              inhibit_pid=
            fi
          fi

          ${pkgs.coreutils}/bin/sleep 10
        done
      '';
      desktopWallpaper = config.stylix.image;
    in
    {
      programs.ydotool.enable = true;

      services = {
        xserver = {
          enable = true;
          xkb.layout = "us";
        };

        displayManager.sddm = {
          enable = true;
          autoNumlock = true;
          settings.General = {
            DisplayServer = "wayland";
          };

          wayland = {
            enable = true;
            compositor = "kwin";
          };
        };

        desktopManager.plasma6.enable = true;
      };

      programs.kdeconnect.enable = true;

      environment = {
        systemPackages = [
          pkgs.kdePackages.xdg-desktop-portal-kde
          pkgs.kdePackages.kcalc
          pkgs.kdePackages.breeze
          pkgs.kdePackages.breeze-gtk
          pkgs.kdePackages.breeze-icons
          pkgs.kdePackages.filelight
        ];

        plasma6.excludePackages = [
          pkgs.kdePackages.elisa
          pkgs.kdePackages.discover
          pkgs.kdePackages.kwalletmanager
        ];
      };

      home-manager.users.${username} = {
        home.packages = [
          pkgs.phinger-cursors
          pkgs.playerctl
          ultrawideWindows
        ];

        systemd.user.services.media-playback-inhibit = {
          Unit = {
            Description = "Prevent sleep and locking while media is playing";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };

          Service = {
            ExecStart = "${mediaPlaybackInhibit}";
            Restart = "always";
            RestartSec = 5;
          };

          Install.WantedBy = [ "graphical-session.target" ];
        };

        programs.plasma = {
          enable = true;
          # overrideConfig = true;

          # Some high-level settings:
          workspace = {
            # clickItemTo = "open"; # If you liked the click-to-open default from plasma 5
            lookAndFeel = "org.kde.breezedark.desktop";
            cursor = {
              theme = "Phinger Cursors (dark)";
              size = 24;
            };
            theme = "breeze-dark";
            colorScheme = "BreezeDark";
            iconTheme = "breeze-dark";
            wallpaper = desktopWallpaper;
          };

          hotkeys.commands."launch-terminal" = {
            name = "Launch Terminal";
            key = "Meta+Ctrl+Alt+Shift+T";
            command = "ghostty";
          };

          hotkeys.commands."launch-terminal-hyper-tab" = {
            name = "Launch Terminal";
            key = "Meta+Ctrl+Alt+Shift+Tab";
            command = "ghostty";
          };

          hotkeys.commands."launch-web-browser" = {
            name = "Launch Web Browser";
            key = "Meta+Ctrl+Alt+Shift+B";
            command = "zen-beta";
          };

          hotkeys.commands."launch-file-browser" = {
            name = "Launch File Browser";
            key = "Meta+Ctrl+Alt+Shift+E";
            command = "dolphin";
          };

          hotkeys.commands."launch-system-settings" = {
            name = "Launch System Settings";
            key = "Meta+Ctrl+Alt+Shift+S";
            command = "systemsettings";
          };

          hotkeys.commands."toggle-vicinae" = {
            name = "Toggle Vicinae";
            key = "Meta+Ctrl+Alt+Shift+Space";
            command = "vicinae toggle";
          };

          fonts = {
            general = {
              family = "Atkinson Hyperlegible Next";
              pointSize = 12;
            };
            fixedWidth = {
              family = "JetBrainsMono Nerd Font Mono";
              pointSize = 12;
            };
          };

          panels = [
            # Panel at the top
            {
              location = "top";
              widgets = [
                # We can configure the widgets by adding the name and config
                # attributes. For example to add the the kickoff widget and set the
                # icon to "nix-snowflake-white" use the below configuration. This will
                # add the "icon" key to the "General" group for the widget in
                # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
                {
                  name = "org.kde.plasma.kickoff";
                  config = {
                    General = {
                      icon = "nix-snowflake-white";
                      alphaSort = true;
                    };
                  };
                }
                "org.kde.plasma.marginsseparator"
                "org.kde.plasma.pager"
                # Adding configuration to the widgets can also for example be used to
                # pin apps to the task-manager, which this example illustrates by
                # pinning dolphin and konsole to the task-manager by default with widget-specific options.
                {
                  iconTasks = {
                    launchers = [
                      # "applications:brave.desktop"
                    ];
                    behavior.showTasks = {
                      onlyInCurrentActivity = false;
                      onlyInCurrentDesktop = false;
                    };
                  };
                }

                "org.kde.plasma.panelspacer"

                # Or you can do it manually, for example:
                # {
                #   name = "org.kde.plasma.icontasks";
                #   config = {
                #     General = {
                #       launchers = [
                #         "applications:org.kde.dolphin.desktop"
                #         "applications:org.kde.konsole.desktop"
                #       ];
                #     };
                #   };
                # }
                # If no configuration is needed, specifying only the name of the
                # widget will add them with the default configuration.
                # "org.kde.plasma.marginsseparator"
                # If you need configuration for your widget, instead of specifying the
                # the keys and values directly using the config attribute as shown
                # above, plasma-manager also provides some higher-level interfaces for
                # configuring the widgets. See modules/widgets for supported widgets
                # and options for these widgets. The widgets below shows two examples
                # of usage, one where we add a digital clock, setting 12h time and
                # first day of the week to Sunday and another adding a systray with
                # some modifications in which entries to show.
                {
                  plasmusicToolbar = {
                    panelIcon = {
                      albumCover = {
                        useAsIcon = false;
                        radius = 8;
                      };
                      icon = "view-media-track";
                    };
                    playbackSource = "auto";
                    musicControls.showPlaybackControls = true;
                    songText = {
                      displayInSeparateLines = true;
                      maximumWidth = 480;
                      scrolling = {
                        behavior = "alwaysScroll";
                        speed = 3;
                      };
                    };
                  };
                }

                "org.kde.plasma.panelspacer"

                {
                  systemTray.items = {
                    shown = [
                      # "org.kde.plasma.battery"
                      "org.kde.plasma.bluetooth"
                      "org.kde.plasma.networkmanagement"
                      "org.kde.plasma.volume"
                    ];
                    # And explicitly hide networkmanagement and volume
                    # hidden = [
                    #   "org.kde.plasma.networkmanagement"
                    #   "org.kde.plasma.volume"
                    # ];
                  };
                }
                {
                  digitalClock = {
                    calendar.firstDayOfWeek = "sunday";
                    time.format = "24h";
                  };
                }
              ];
              # hiding = "autohide";
            }
            ## Application name, Global menu and Song information and playback controls at the top
            # {
            #   location = "bottom";
            #   height = 32;
            #   widgets = [
            #     {
            #       applicationTitleBar = {
            #         behavior = {
            #           activeTaskSource = "activeTask";
            #         };
            #         layout = {
            #           elements = [ "windowTitle" ];
            #           horizontalAlignment = "left";
            #           showDisabledElements = "deactivated";
            #           verticalAlignment = "center";
            #         };
            #         overrideForMaximized.enable = false;
            #         titleReplacements = [
            #           {
            #             type = "regexp";
            #             originalTitle = "^Brave Web Browser$";
            #             newTitle = "Brave";
            #           }
            #           {
            #             type = "regexp";
            #             originalTitle = ''\\bDolphin\\b'';
            #             newTitle = "File manager";
            #           }
            #         ];
            #         windowTitle = {
            #           font = {
            #             bold = false;
            #             fit = "fixedSize";
            #             size = 12;
            #           };
            #           hideEmptyTitle = true;
            #           margins = {
            #             bottom = 0;
            #             left = 10;
            #             right = 5;
            #             top = 0;
            #           };
            #           source = "appName";
            #         };
            #       };
            #     }
            #     "org.kde.plasma.appmenu"
            #     "org.kde.plasma.panelspacer"
            #     {
            #       plasmusicToolbar = {
            #         panelIcon = {
            #           albumCover = {
            #             useAsIcon = false;
            #             radius = 8;
            #           };
            #           icon = "view-media-track";
            #         };
            #         playbackSource = "auto";
            #         musicControls.showPlaybackControls = true;
            #         songText = {
            #           displayInSeparateLines = true;
            #           maximumWidth = 640;
            #           scrolling = {
            #             behavior = "alwaysScroll";
            #             speed = 3;
            #           };
            #         };
            #       };
            #     }
            #   ];
            # }
          ];

          window-rules = [
            {
              description = "Dolphin";
              match = {
                window-class = {
                  value = "dolphin";
                  type = "substring";
                };
                window-types = [ "normal" ];
              };
              apply = {
                noborder = {
                  value = false;
                  apply = "force";
                };
                # `apply` defaults to "apply-initially"
                #maximizehoriz = true;
                #maximizevert = true;
              };
            }
          ];

          powerdevil = {
            AC = {
              powerButtonAction = "lockScreen";
              autoSuspend = {
                action = "sleep";
                idleTimeout = 3600;
              };
              turnOffDisplay = {
                idleTimeout = 1000;
                idleTimeoutWhenLocked = "immediately";
              };
            };
            battery = {
              powerButtonAction = "sleep";
              whenSleepingEnter = "standbyThenHibernate";
            };
            lowBattery = {
              whenLaptopLidClosed = "hibernate";
            };
          };

          kwin = {
            effects = {
              minimization.animation = "off";
              desktopSwitching.animation = "off";
              windowOpenClose.animation = "off";
            };
          };

          kscreenlocker = {
            lockOnResume = true;
            timeout = 60;
          };

          #
          # Some mid-level settings:
          #
          shortcuts = {
            ksmserver = {
              "Lock Session" = [
                "Screensaver"
                "Meta+Ctrl+Alt+L"
              ];
            };

            kwin = {
              "Expose" = "Meta+Space";
              "Switch Window Down" = "Meta+J";
              "Switch Window Left" = "Meta+H";
              "Switch Window Right" = "Meta+L";
              "Switch Window Up" = "Meta+K";

              "Window Quick Tile Bottom" = "none";
              "Window Quick Tile Bottom Left" = "none";
              "Window Quick Tile Bottom Right" = "none";
              "Window Quick Tile Left" = "none";
              "Window Quick Tile Right" = "none";
              "Window Quick Tile Top" = "none";
              "Window Quick Tile Top Left" = "none";
              "Window Quick Tile Top Right" = "none";

              # CTRL As Indicator For Cohesive Layer
              # Ultrawide - Default Layer [ 25 | 50 | 25 ]%
              MoveWindowToUpLeft4x2_centerbiased = "Ctrl+Num+7";
              MoveWindowToUpCenter4x2_centerbiased = "Ctrl+Num+8";
              MoveWindowToUpRight4x2_centerbiased = "Ctrl+Num+9";
              MoveWindowToLeftHeight4x2_centerbiased = "Ctrl+Num+4";
              MoveWindowToCenterHeight4x2_centerbiased = "Ctrl+Num+5";
              MoveWindowToRightHeight4x2_centerbiased = "Ctrl+Num+6";
              MoveWindowToDownLeft4x2_centerbiased = "Ctrl+Num+1";
              MoveWindowToDownCenter4x2_centerbiased = "Ctrl+Num+2";
              MoveWindowToDownRight4x2_centerbiased = "Ctrl+Num+3";

              # CTRL + Meta For Larger Center Than Default
              # Ultrawide - Wider Center Layer [ 16 | 68 | 16 ]%
              MoveWindowToUpLeft23_center_biased = "Ctrl+Meta+Num+7";
              MoveWindowToUpCenter23_center_biased = "Ctrl+Meta+Num+8";
              MoveWindowToUpRight23_center_biased = "Ctrl+Meta+Num+9";
              MoveWindowToLeftHeight23_center_biased = "Ctrl+Meta+Num+4";
              MoveWindowToCenterHeight23_center_biased = "Ctrl+Meta+Num+5";
              MoveWindowToRightHeight23_center_biased = "Ctrl+Meta+Num+6";
              MoveWindowToFitDownLeft23_center_biased = "Ctrl+Meta+Num+1";
              MoveWindowToDownCenter23_center_biased = "Ctrl+Meta+Num+2";
              MoveWindowToFitDownRight23_center_biased = "Ctrl+Meta+Num+3";

              # CTRL + Alt For Smaller Center Than Default
              # Ultrawide - Smaller Center Layer [ 33 | 33 | 33 ]%
              MoveWindowToUpLeft3x2 = "Ctrl+Alt+Num+7";
              MoveWindowToUpCenter3x2 = "Ctrl+Alt+Num+8";
              MoveWindowToUpRight3x2 = "Ctrl+Alt+Num+9";
              MoveWindowToLeftHeight3x2 = "Ctrl+Alt+Num+4";
              MoveWindowToCenterHeight3x2 = "Ctrl+Alt+Num+5";
              MoveWindowToRightHeight3x2 = "Ctrl+Alt+Num+6";
              MoveWindowToDownLeft3x2 = "Ctrl+Alt+Num+1";
              MoveWindowToDownCenter3x2 = "Ctrl+Alt+Num+2";
              MoveWindowToDownRight3x2 = "Ctrl+Alt+Num+3";

              # General
              MoveWindowToMaximize = "Ctrl+Num+0";

              # 1/2 Width
              MoveWindowToUpLeft2x2 = "Meta+Num+7";
              MoveWindowToUpCenter2x2 = "Meta+Num+8";
              MoveWindowToUpRight2x2 = "Meta+Num+9";
              MoveWindowToLeftHeight2x2 = "Meta+Num+4";
              MoveWindowToCenter = "Meta+Num+5";
              MoveWindowToRightHeight2x2 = "Meta+Num+6";
              MoveWindowToDownLeft2x2 = "Meta+Num+1";
              MoveWindowToDownCenter2x2 = "Meta+Num+2";
              MoveWindowToDownRight2x2 = "Meta+Num+3";

              # 2/3 Width
              MoveWindowToUpLeft23 = "Alt+Num+7";
              MoveWindowToUpCenter23 = "Alt+Num+8";
              MoveWindowToUpRight23 = "Alt+Num+9";
              MoveWindowToLeftHeight23 = "Alt+Num+4";
              MoveWindowToRightHeight23 = "Alt+Num+6";
              MoveWindowToFitDownLeft23 = "Alt+Num+1";
              MoveWindowToDownCenter23 = "Alt+Num+2";
              MoveWindowToFitDownRight23 = "Alt+Num+3";

              # Nudging - Already Defaults
              # IncreaseWindowSize = "Ctrl+Meta+Num++";
              # DecreaseWindowSize = "Ctrl+Meta+Num+-";
              # MoveWindowLeft = "Ctrl+Meta+Left";
              # MoveWindowRight = "Ctrl+Meta+Right";
              # MoveWindowUp = "Ctrl+Meta+Up";
              # MoveWindowDown = "Ctrl+Meta+Down";
            };
          };

          #
          # Some low-level settings:
          #
          configFile = {
            baloofilerc."Basic Settings"."Indexing-Enabled" = false;
            kcminputrc.Keyboard.NumLock = 0;
            kdeglobals.KDE.AnimationDurationFactor = 0;
            kwinrc.Compositing.AnimationSpeed = 0;
            kwinrc.Plugins.slidingpopupsEnabled = false;
            kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "SF";
            kwinrc.ModifierOnlyShortcuts.Meta = "";
            kwinrc.Plugins.ultrawidewindowsEnabled = true;
            kwinrc.Desktops.Number = {
              value = 1;
            };
            kscreenlockerrc = {
              Greeter.WallpaperPlugin = "org.kde.image";
              "Greeter/Wallpaper/org.kde.image/General" = {
                Image = "file://${toString desktopWallpaper}";
                PreviewImage = "file://${toString desktopWallpaper}";
              };
            };
          };
        };
      };

      environment.etc."xdg/kcminputrc".text = ''
        [Keyboard]
        NumLock=0
      '';

      environment.etc."plasmalogin.conf".text = ''
        [Greeter]
        WallpaperPluginId=org.kde.image

        [Greeter][Wallpaper][org.kde.image][General]
        FillMode=2
        Image=file://${toString desktopWallpaper}
        PreviewImage=file://${toString desktopWallpaper}
      '';
    };
}
