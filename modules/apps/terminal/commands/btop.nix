{ inputs, ... }:
{
  flake.nixosModules.btop =
    {
      pkgs,
      username,
      # terminalTheme,
      ...
    }:
    {
      home-manager.users.${username} = {
        programs.btop = {
          enable = true;
          package = pkgs.btop;

          # settings = {
          #   color_theme = "reactor";
          #   theme_background = false;
          #   truecolor = true;
          # };

          # themes.reactor = terminalTheme.btop;
        };
      };
    };
}
