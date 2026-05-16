{ inputs, ... }:
{
  flake.nixosModules.brave =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.brave ];
      };
    };
}
