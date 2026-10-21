{
  inputs,
  commonArgs,
  system,
  self,
  ...
}:
let
  mkHalcyon =
    {
      name,
      nixpkgs ? inputs.nixpkgs,
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./_hardware-configuration.nix
        self.nixosModules.halcyon
      ] ++ extraModules;

      specialArgs = commonArgs // {
        host = name;
      };
    };
in
{
  flake.nixosConfigurations = {
    halcyon = mkHalcyon {
      name = "halcyon";
    };

    halcyon-plasma-beta = mkHalcyon {
      name = "halcyon-plasma-beta";
      nixpkgs = inputs.nixpkgs-plasma-beta;
      extraModules = [
        (
          { lib, ... }:
          {
            services.displayManager = {
              sddm.enable = lib.mkForce false;
              plasma-login-manager.enable = true;
            };

            system.nixos.tags = [ "plasma-67" ];
            system.stateVersion = inputs.nixpkgs.lib.mkDefault "25.11";
          }
        )
      ];
    };
  };

  flake.nixosModules.halcyon =
    { ... }:
    {
      imports = [
        self.nixosModules.apps
        self.nixosModules.core
        self.nixosModules.desktop-environments
        self.nixosModules.nix
      ];

      # Extra disk-backed capacity for concurrent builds; keep zram preferred.
      swapDevices = [
        {
          device = "/swapfile";
          size = 64 * 1024; # MiB (64 GiB)
          priority = 1;
        }
      ];

      nixos = {
        # hardware.bluetooth = {
        #   enable = true;
        #   powerOnBoot = true;
        # };

        performance = {
          kernel = "performance";
        };
      };

      # Encode on the RX 7900 XTX (renderD129 is the integrated GPU).
      services.helios.settings.adapter_name = "/dev/dri/renderD128";

      # Second NVMe (NE-512, 476.9 GB): scratch for Jet dev build artifacts.
      # nofail: the system still boots if the drive is missing or unformatted.
      fileSystems."/mnt/jetscratch" = {
        device = "/dev/disk/by-label/jetscratch";
        fsType = "ext4";
        options = [
          "noatime"
          "nofail"
          "x-systemd.device-timeout=5s"
        ];
      };
      systemd.tmpfiles.rules = [ "d /mnt/jetscratch 0755 nate users -" ];
      # Jet dev: off-drive cargo targets, candidates and scratch (Tools/agent/jet-env).
      environment.variables.JET_SCRATCH_ROOT = "/mnt/jetscratch";
    };
}
