{ inputs, ... }:
{
  flake.nixosModules.onlyoffice =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.onlyoffice-desktopeditors ];
      };
    };
}
