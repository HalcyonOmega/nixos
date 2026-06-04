{ ... }:
{
  flake.nixosModules.lapce =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.lapce ];
      };
    };
}
