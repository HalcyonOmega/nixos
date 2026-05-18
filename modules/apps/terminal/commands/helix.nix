{ inputs, ... }:
{
  flake.nixosModules.helix =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.helix
        ];

        programs.helix = {
          enable = true;
          settings = {
            # theme = "tokyonight_transparent";
            editor = {
              cursor-shape = {
                normal = "block";
                insert = "bar";
                select = "underline";
              };
              fonts.primary = {
                family = "AtkynsonMono Nerd Font Mono";
                weight = "regular";
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
            tokyonight_transparent = {
              "inherits" = "tokyonight";
              "ui.background" = { };
            };
          };
        };
      };
    };
}
