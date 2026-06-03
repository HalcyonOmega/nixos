{ ... }:
{
  flake.nixosModules.helix =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.helix
        ];

        stylix.targets.helix.enable = false;

        home.sessionVariables = {
          EDITOR = "hx";
          VISUAL = "hx";
        };

        programs.helix = {
          enable = true;
          settings = {
            theme = "reactor";
            editor = {
              cursor-shape = {
                normal = "block";
                insert = "bar";
                select = "underline";
              };
            };
          };
          languages.language = [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
            }
          ];
          themes = {
            reactor = {
              "inherits" = "base16_default_dark";

              "palette" = {
                base00 = "#0b0f14";
                base01 = "#141a21";
                base02 = "#222b35";
                base03 = "#53616f";
                base04 = "#8d9aa7";
                base05 = "#c8d0d8";
                base06 = "#e4e9ee";
                base07 = "#f7f9fb";
                base08 = "#ff4f58";
                base09 = "#ff9f43";
                base0A = "#f6c85f";
                base0B = "#7bd88f";
                base0C = "#3dd6d0";
                base0D = "#46b4ff";
                base0E = "#9d7cff";
                base0F = "#d0765f";
              };
            };
          };
        };
      };
    };
}
