{ pkgs, modulesPath, ... }:
{

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = [
    pkgs.disko
    pkgs.git
    pkgs.micro
  ];

  programs.hyprland.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
