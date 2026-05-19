{ inputs, ... }:
{
  flake.nixosModules.network =
    { pkgs, host, ... }:
    {
      networking = {
        hostName = "${host}";
        networkmanager.enable = true;
        nameservers = [
          "1.1.1.1"
          "1.0.0.1"
          "8.8.8.8"
        ];
        firewall = {
          enable = true;
          allowedTCPPorts = [
            22
            80
            443
            53317
          ];
          allowedUDPPorts = [
            # 19132
            53317
          ];
        };
      };

      environment.systemPackages = [ pkgs.networkmanagerapplet ];
    };
}
