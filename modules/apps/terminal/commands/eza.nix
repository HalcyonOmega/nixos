{ inputs, ... }:
{
  flake.nixosModules.eza =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.eza
        ];
      };
    };
}
