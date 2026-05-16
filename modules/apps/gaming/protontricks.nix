{ inputs, ... }:
{
  flake.nixosModules.protontricks =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.protontricks ];
      };
    };
}
