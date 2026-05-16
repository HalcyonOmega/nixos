{ inputs, ... }:
{
  flake.nixosModules.discord =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.discord ];
      };
    };
}
