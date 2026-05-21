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
        self.nixosModules.aliases
      ];

      nixpkgs.hostPlatform = "x86_64-linux";

      environment.systemPackages = [
        # pkgs.disko
        pkgs.gparted
        pkgs.git
        pkgs.nixos-install-tools
        pkgs.helix
        pkgs.fastfetch
        pkgs.bat
        pkgs.eza
        pkgs.yazi
        pkgs.zoxide
        pkgs.fzf
        pkgs.cmatrix
        pkgs.btop
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      boot.zfs.forceImportRoot = false;
    };
}
