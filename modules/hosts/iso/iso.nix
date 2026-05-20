{ inputs, self, ... }:
{
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      self.nixosModules.isoModule
    ];
  };

  flake.nixosModules.isoModule =
    { pkgs, modulesPath, ... }:
    {

      imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
        "${modulesPath}/installer/cd-dvd/channel.nix"
      ];

      nixpkgs.hostPlatform = "x86_64-linux";

      environment.systemPackages = [
        # pkgs.disko
        pkgs.gparted
        pkgs.git
        pkgs.nixos-install-tools
        pkgs.micro
        pkgs.xfsprogs
      ];

      programs.hyprland.enable = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
}
