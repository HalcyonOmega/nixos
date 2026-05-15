{ pkgs, username, ... }:
{
  # User groups are managed in user.nix to avoid conflicts
  # users.users.${username}.extraGroups = [ "libvirtd" ];

  # Install necessary packages
  environment.systemPackages = [
    pkgs.virt-manager
    pkgs.virt-viewer
    pkgs.spice
    pkgs.spice-gtk
    pkgs.spice-protocol
    pkgs.virtio-win
    pkgs.win-spice
  ];

  # Manage the virtualisation services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
