{ inputs, ... }:
{
  flake.nixosModules.cursor =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.code-cursor ];
      };
    };
}
