{ inputs, ... }:
{
  flake.nixosModules.element =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.element-desktop ];
      };
    };
}
