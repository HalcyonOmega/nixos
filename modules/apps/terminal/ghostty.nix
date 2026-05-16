{ inputs, ... }:
{
  flake.nixosModules.ghostty =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.ghostty ];
      };
    };
}
