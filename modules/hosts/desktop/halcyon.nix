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
      self.nixosModules.apps
      self.nixosModules.core
      self.nixosModules.desktop-environments
      self.nixosModules.nix
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
      # nexos.performance = {
      #   kernel = "performance";
      #   cachyosKernelCache = true;
      # };
    };
}
