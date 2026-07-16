{ inputs, ... }:
{
  flake.nixosModules.twingate =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      network = "halcyonyx";
      envFile = "/etc/twingate/connector.env";
    in
    {
      # Client daemon needs interactive `sudo twingate setup` before it can
      # start — enabling services.twingate breaks `nh os switch` until then.
      # For publishing Tower to remotes we only need the Connector below.
      # Optional: install CLI so you can still run setup on this box later.
      environment.systemPackages = [ pkgs.twingate ];

      # Connector — publish local services (Tower :7878) to remote Twingate clients.
      # Tokens live outside the flake (SOPS later). Create envFile from admin console:
      #   Remote Networks → <network> → Add Connector → Docker → generate tokens
      #   TWINGATE_ACCESS_TOKEN=...
      #   TWINGATE_REFRESH_TOKEN=...
      # Resource for Tower: 127.0.0.1 TCP 7878 (host-network connector)
      virtualisation.docker.enableOnBoot = lib.mkForce true;

      virtualisation.oci-containers = {
        backend = "docker";
        containers.twingate-connector = {
          image = "twingate/connector:1";
          autoStart = true;
          extraOptions = [
            "--network=host"
            "--sysctl=net.ipv4.ping_group_range=0 2147483647"
          ];
          environment = {
            TWINGATE_NETWORK = network;
            TWINGATE_LABEL_HOSTNAME = config.networking.hostName;
          };
          environmentFiles = [ envFile ];
        };
      };

      # Don't fail the boot graph when tokens aren't dropped yet.
      systemd.services."docker-twingate-connector" = {
        unitConfig.ConditionPathExists = envFile;
        serviceConfig.Restart = lib.mkForce "always";
        serviceConfig.RestartSec = 10;
      };

      environment.etc."twingate/connector.env.example" = {
        mode = "0644";
        text = ''
          # Copy to ${envFile} (mode 0600, root-owned), then:
          #   sudo systemctl restart docker-twingate-connector
          #
          # Network: ${network}.twingate.com
          # Resource for Tower: 127.0.0.1 TCP 7878 (host-network connector)
          TWINGATE_ACCESS_TOKEN=
          TWINGATE_REFRESH_TOKEN=
        '';
      };

      systemd.tmpfiles.rules = [
        "d /etc/twingate 0755 root root -"
      ];

      home-manager.users.${username} = {
        home.packages = [ pkgs.twingate ];
      };
    };
}
