{ inputs, ... }:
{
  flake.nixosModules.starship =
    {
      pkgs,
      username,
      terminalTheme,
      ...
    }:
    let
      lib = pkgs.lib;
      c = terminalTheme.colors;
      scheme = c.scheme;
      # Tokyo Night preset layout; colors = Reactor (reactor.yaml → terminalTheme.colors).
      palette = {
        color_tn_1 = "#${scheme.base04}";
        color_tn_2 = c.blue;
        color_tn_3 = c."selection-background";
        color_tn_4 = c.lineHighlight;
        color_tn_5 = c.background;
        color_text_light = c.brightWhite;
        color_text_dark = c.black;
        color_text_muted = c.foreground;
        color_green = c.green;
        color_red = c.red;
        color_purple = c.magenta;
        color_yellow = c.yellow;
      };
    in
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.starship
        ];

        programs.starship = {
          enable = true;
          enableFishIntegration = true;

          settings = {
            "$schema" = "https://starship.rs/config-schema.json";

            # palette = "reactor";
            # palettes.reactor = palette;

            # Same modules / separators as `starship preset tokyo-night`; single line (no `\` escapes —
            # Starship treats `\` as an escape sequence and errors on `\` + newline from TOML/HM).
            format = lib.concatStrings [
              "[█](fg:color_tn_1)"
              "$os"
              "[](bg:color_tn_2 fg:color_tn_1)"
              "$directory"
              "[](fg:color_tn_2 bg:color_tn_3)"
              "$git_branch"
              "$git_status"
              "[](fg:color_tn_3 bg:color_tn_4)"
              "$nodejs"
              "$bun"
              "$rust"
              "$golang"
              "$php"
              "[](fg:color_tn_4 bg:color_tn_5)"
              "$time"
              "[ ](fg:color_tn_5)"
              "$line_break"
              "$character"
            ];

            os = {
              disabled = false;
              format = "[ $symbol ]($style)";
              style = "bg:color_tn_1 fg:color_text_dark";

              symbols = {
                Windows = "󰍲";
                Ubuntu = "󰕈";
                SUSE = "";
                Raspbian = "󰐿";
                Mint = "󰣭";
                Macos = "";
                Manjaro = "";
                Linux = "󰌽";
                Gentoo = "󰣨";
                Fedora = "󰣛";
                Alpine = "";
                Amazon = "";
                Android = "";
                AOSC = "";
                Arch = "󰣇";
                Artix = "󰣇";
                EndeavourOS = "";
                CentOS = "";
                Debian = "󰣚";
                Redhat = "󱄛";
                RedHatEnterprise = "󱄛";
                Pop = "";
              };
            };

            directory = {
              style = "fg:color_text_light bg:color_tn_2";
              format = "[ $path ]($style)";
              truncation_length = 3;
              truncation_symbol = "…/";

              substitutions = {
                Documents = "󰈙 ";
                Downloads = " ";
                Music = " ";
                Pictures = " ";
              };
            };

            git_branch = {
              symbol = "";
              style = "bg:color_tn_3";
              format = "[[ $symbol $branch ](fg:color_tn_2 bg:color_tn_3)]($style)";
            };

            git_status = {
              style = "bg:color_tn_3";
              format = "[[($all_status$ahead_behind )](fg:color_tn_2 bg:color_tn_3)]($style)";
            };

            nodejs = {
              symbol = "";
              style = "bg:color_tn_4";
              format = "[[ $symbol ($version) ](fg:color_tn_2 bg:color_tn_4)]($style)";
            };

            bun = {
              symbol = "";
              style = "bg:color_tn_4";
              format = "[[ $symbol ($version) ](fg:color_tn_2 bg:color_tn_4)]($style)";
            };

            rust = {
              symbol = "";
              style = "bg:color_tn_4";
              format = "[[ $symbol ($version) ](fg:color_tn_2 bg:color_tn_4)]($style)";
            };

            golang = {
              symbol = "";
              style = "bg:color_tn_4";
              format = "[[ $symbol ($version) ](fg:color_tn_2 bg:color_tn_4)]($style)";
            };

            php = {
              symbol = "";
              style = "bg:color_tn_4";
              format = "[[ $symbol ($version) ](fg:color_tn_2 bg:color_tn_4)]($style)";
            };

            time = {
              disabled = false;
              time_format = "%R";
              style = "bg:color_tn_5";
              format = "[[  $time ](fg:color_text_muted bg:color_tn_5)]($style)";
            };

            line_break.disabled = false;

            character = {
              disabled = false;
              success_symbol = "[❯](bold fg:color_green)";
              error_symbol = "[❯](bold fg:color_red)";
              vimcmd_symbol = "[❮](bold fg:color_green)";
              vimcmd_replace_one_symbol = "[❮](bold fg:color_purple)";
              vimcmd_replace_symbol = "[❮](bold fg:color_purple)";
              vimcmd_visual_symbol = "[❮](bold fg:color_yellow)";
            };
          };
        };
      };
    };
}
