{ inputs, ... }:
{
  flake.nixosModules.qt =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        qt = {
          enable = true;
          platformTheme.name = "gtk2";
          style = "gtk2";
        };
      };
    };
}
