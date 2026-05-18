{ inputs, ... }:
{
  flake.nixosModules.podman =
    { pkgs, ... }:
    {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      environment.systemPackages = [
        pkgs.docker-compose
      ];
    };
}
