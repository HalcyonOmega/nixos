{ inputs, ... }:
{
  flake.nixosModules.smartcard =
    { pkgs, username, ... }:
    {
      # home-manager.users.${username} = {
      #   home.packages = [ pkgs.smartcard ];
      # };

      services.pcscd.enable = true;
      environment.systemPackages = [
        pkgs.pcsclite
        pkgs.pcsc-tools
        pkgs.opensc
        pkgs.ccid
        pkgs.nssTools
      ];

    };
}
