{ inputs, ... }:
{
  flake.nixosModules.plasma-manager =
    {
      config,
      pkgs,
      username,
      ...
    }:
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
            Numlock = "on";
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
          # kdenlive
          # plasma-browser-integration
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
        ];

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
            wallpaper = ./../../../assets/wallpapers/vortex.jpg;
          };

          hotkeys.commands."launch-terminal" = {
            name = "Launch Terminal";
            key = "Meta+Ctrl+Alt+Shift+T";
            command = "ghostty";
          };

          hotkeys.commands."launch-file-browser" = {
            name = "Launch File Browser";
            key = "Meta+Ctrl+Alt+Shift+E";
            command = "dolphin";
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
              family = "AtkynsonMono Nerd Font Mono";
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
                maximizehoriz = true;
                maximizevert = true;
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

          # kwin = {
          #   edgeBarrier = 0; # Disables the edge-barriers introduced in plasma 6.1
          #   cornerBarrier = false;

          #   scripts.polonium.enable = true
          # };

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
              "Expose" = "Meta+,";
              "Switch Window Down" = "Meta+J";
              "Switch Window Left" = "Meta+H";
              "Switch Window Right" = "Meta+L";
              "Switch Window Up" = "Meta+K";
              # Show all windows on the current desktop using Meta+Tab
              "Toggle Overview" = "Meta+Tab";

              "Window Close" = [
                "Alt+F4"
                "Meta+Ctrl+Alt+Shift+Q"
              ];
            };
          };

          #
          # Some low-level settings:
          #
          configFile = {
            baloofilerc."Basic Settings"."Indexing-Enabled" = false;
            kcminputrc.Keyboard.NumLock = 0;
            kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "SF";
            kwinrc.ModifierOnlyShortcuts.Meta = "org.kde.kglobalaccel,/component/kwin,org.kde.kglobalaccel.Component,invokeShortcut,Overview";
            kwinrc.Desktops.Number = {
              value = 1;
            };
            kscreenlockerrc = {
              Greeter.WallpaperPlugin = "org.kde.potd";
              # To use nested groups use / as a separator. In the below example,
              # Provider will be added to [Greeter][Wallpaper][org.kde.potd][General].
              "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
            };
          };
        };
      };
    };
}
