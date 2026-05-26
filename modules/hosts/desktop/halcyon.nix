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
            nixpkgs.overlays = [
              (import ../../../overlays/kde-plasma-6-7-beta.nix)
            ];

            services.displayManager = {
              sddm.enable = lib.mkForce false;
              plasma-login-manager.enable = true;
            };

            system.nixos.tags = [ "plasma-beta" ];
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

      nixos = {
        # hardware.bluetooth = {
        #   enable = true;
        #   powerOnBoot = true;
        # };

        performance = {
          kernel = "performance";
        };
      };
    };
}
