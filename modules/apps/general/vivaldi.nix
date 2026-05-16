{ inputs, ... }:
{
  flake.nixosModules.vivaldi =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.vivaldi ];
      };
    };
}
