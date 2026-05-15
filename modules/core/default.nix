{ ... }:
{
  imports = [
    ./appimage.nix
    ./bluetooth.nix
    ./bootloader.nix
    ./flatpak.nix
    ./kde.nix
    ./mouse.nix
    ./network.nix
    ./nvidia.nix
    ./pipewire.nix
    ./program.nix
    ./sched-ext.nix
    ./security.nix
    # ./style.nix
    ./system.nix
    ./user.nix
    ./virtualization.nix
    ./wayland.nix
    ./zram.nix
  ];
}
