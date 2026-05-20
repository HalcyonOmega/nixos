{
  inputs,
  username,
  githubEmail,
  githubUsername,
  pkgs-stable,
  commonArgs,
  system,
  self,
  ...
}:
{
  flake.nixosConfigurations.halcyon = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ./hardware-configuration.nix
      self.nixosModules.apps
      self.nixosModules.core
      self.nixosModules.desktop-environments
      self.nixosModules.nix
      self.nixosModules.halcyon

      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "backup";
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.sharedModules = [
          inputs.plasma-manager.homeModules.plasma-manager
          inputs.nixcord.homeModules.nixcord
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.vicinae.homeManagerModules.default
        ];
        home-manager.extraSpecialArgs = {
          inherit
            inputs
            username
            githubEmail
            githubUsername
            pkgs-stable
            ;
          host = "halcyon";
        };
        home-manager.users.${username} = {
          home.stateVersion = "26.05";
        };
      }
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
      nexos.performance = {
        kernel = "performance";
        cachyosKernelCache = true;
      };
    };
}
