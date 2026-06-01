{ inputs, ... }:
{
  flake.nixosModules.winboat =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.freerdp
          pkgs.winboat
        ];
      };
    };
}
