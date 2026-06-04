{ inputs, ... }:
{
  flake.nixosModules.qalculate =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.qalculate-gtk ];
      };
    };
}
