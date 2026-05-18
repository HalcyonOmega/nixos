{ inputs, ... }:
{
  flake.nixosModules.localsend =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.localsend ];
      };
    };
}
