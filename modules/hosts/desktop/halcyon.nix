{
  inputs,
  commonArgs,
  system,
  self,
  ...
}:
{
  flake.nixosConfigurations.halcyon = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ./_hardware-configuration.nix
      self.nixosModules.halcyon
    ];

    specialArgs = commonArgs // {
      host = "halcyon";
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
