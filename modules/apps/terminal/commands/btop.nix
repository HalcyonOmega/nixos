{ inputs, ... }:
{
  flake.nixosModules.btop =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.btop
        ];
      };
    };
}
