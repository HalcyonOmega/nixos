{ inputs, ... }:
{
  flake.nixosModules.starship =
    {
      pkgs,
      username,
      ...
    }:
    let
      lib = pkgs.lib;
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

            # Stylix supplies the `base16` palette from assets/themes/reactor.yaml.
            format = lib.concatStrings [
              "$username"
              "$directory"
              "$git_branch"
              "$git_status"
              "$status"
              "$cmd_duration"
              "$jobs"
              "$nix_shell"
              "$nodejs"
              "$bun"
              "$rust"
              "$golang"
              "$php"
              "$time"
              "$line_break"
              "$character"
            ];

            username = {
              disabled = false;
              show_always = true;
              format = "[ $user ]($style)";
              style_user = "bold fg:black bg:cyan";
              style_root = "bold fg:black bg:red";
            };

            directory = {
              style = "bold fg:black bg:blue";
              read_only = " 󰌾";
              format = "[ $path$read_only ]($style)";
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
              style = "bold fg:black bg:purple";
              format = "[ $symbol $branch ]($style)";
            };

            git_status = {
              style = "bold fg:black bg:yellow";
              format = "[ $all_status$ahead_behind ]($style)";
              conflicted = "=\${count}";
              ahead = "⇡\${count}";
              behind = "⇣\${count}";
              diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
              untracked = "?\${count}";
              stashed = "$\${count}";
              modified = "!\${count}";
              staged = "+\${count}";
              renamed = "»\${count}";
              deleted = "✘\${count}";
            };

            nodejs = {
              symbol = "";
              style = "bold fg:black bg:green";
              format = "[ $symbol $version ]($style)";
            };

            bun = {
              symbol = "";
              style = "bold fg:black bg:orange";
              format = "[ $symbol $version ]($style)";
            };

            rust = {
              symbol = "";
              style = "bold fg:black bg:orange";
              format = "[ $symbol $version ]($style)";
            };

            golang = {
              symbol = "";
              style = "bold fg:black bg:cyan";
              format = "[ $symbol $version ]($style)";
            };

            php = {
              symbol = "";
              style = "bold fg:black bg:purple";
              format = "[ $symbol $version ]($style)";
            };

            nix_shell = {
              symbol = "";
              style = "bold fg:black bg:blue";
              format = "[ $symbol $state( \\($name\\)) ]($style)";
              impure_msg = "impure";
              pure_msg = "pure";
              unknown_msg = "shell";
            };

            cmd_duration = {
              min_time = 2000;
              style = "bold fg:black bg:yellow";
              format = "[  $duration ]($style)";
            };

            jobs = {
              symbol = "";
              style = "bold fg:white bg:bright-black";
              format = "[ $symbol $number ]($style)";
            };

            status = {
              disabled = false;
              symbol = "✘";
              style = "bold fg:black bg:red";
              format = "[ $symbol $status ]($style)";
            };

            time = {
              disabled = false;
              time_format = "%R";
              style = "bold fg:white bg:bright-black";
              format = "[  $time ]($style) ";
            };

            line_break.disabled = false;

            character = {
              disabled = false;
              success_symbol = "[❯](bold fg:green)";
              error_symbol = "[❯](bold fg:red)";
              vimcmd_symbol = "[❮](bold fg:green)";
              vimcmd_replace_one_symbol = "[❮](bold fg:purple)";
              vimcmd_replace_symbol = "[❮](bold fg:purple)";
              vimcmd_visual_symbol = "[❮](bold fg:yellow)";
            };
          };
        };
      };
    };
}
