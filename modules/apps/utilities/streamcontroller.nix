{ inputs, ... }:
{
  flake.nixosModules.streamcontroller =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.streamcontroller ];
      };
    };
}
