{ inputs, ... }:
{
  # Docker-compatible CLI + `/run/docker.sock` (Podman-backed) for Dev Containers and compose tooling.
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
