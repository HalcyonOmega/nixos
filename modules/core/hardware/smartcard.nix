{ inputs, ... }:
{
  flake.nixosModules.smartcard =
    { pkgs, ... }:
    {
      services.pcscd = {
        enable = true;
        plugins = [ pkgs.ccid ];
      };

      environment.systemPackages = [
        pkgs.pcsclite
        pkgs.pcsc-tools
        pkgs.opensc
        pkgs.nssTools
      ];

    };
}
