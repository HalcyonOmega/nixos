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
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        self.nixosModules.apps
        self.nixosModules.core
        self.nixosModules.desktop-environments
        self.nixosModules.nix
      ];

      nexos = {
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
