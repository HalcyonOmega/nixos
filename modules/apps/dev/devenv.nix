{ inputs, ... }:
{
  flake.nixosModules.devenv =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.devenv ];
      };
    };
}
