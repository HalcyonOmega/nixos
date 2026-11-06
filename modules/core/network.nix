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
            3000
            3001 # LAN dev/testing
            3002 # LAN dev/testing
            3773
            5173 # LAN dev/testing (Vite default)
            5174 # LAN dev/testing
            7878
            8000 # LAN dev/testing
            8080
            8899
            53317 # Localsend
          ];
          allowedUDPPorts = [
            53317 # Localsend
          ];
        };
      };

      environment.systemPackages = [ pkgs.networkmanagerapplet ];
    };
}
