{ inputs, ... }:
{
  flake.nixosModules.tailscale =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.tailscale
          pkgs.cifs-utils
        ];

        services.tailscale.enable = true;
      };
    };
}
