{ ... }:
{
  flake.nixosModules.zed =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.zed-editor ];
      };
    };
}
