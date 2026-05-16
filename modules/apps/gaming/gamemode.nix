{ inputs, ... }:
{
  flake.nixosModules.gamemode =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.gamemode ];
      };
    };
}
