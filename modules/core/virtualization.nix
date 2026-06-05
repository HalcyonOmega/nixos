{ inputs, ... }:
{
  flake.nixosModules.virtualization =
    { pkgs, username, ... }:
    {
      # User groups are managed in user.nix to avoid conflicts
      # users.users.${username}.extraGroups = [ "libvirtd" ];

      programs.virt-manager.enable = true;

      # Install additional virtualization tools and guest integration packages
      environment.systemPackages = [
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
            runAsRoot = false;
            swtpm.enable = true;
          };
        };
        spiceUSBRedirection.enable = true;
      };
      services.spice-vdagentd.enable = true;
    };
}
