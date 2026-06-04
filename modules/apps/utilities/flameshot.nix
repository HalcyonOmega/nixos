{ inputs, ... }:
{
  flake.nixosModules.flameshot =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.flameshot ];
      };
    };
}
