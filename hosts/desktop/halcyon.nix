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
      self.nixosModules.apps
      self.nixosModules.core
      self.nixosModules.desktop-environments
      self.nixosModules.halcyon
      ./hardware-configuration.nix
      # inputs.stylix.nixosModules.stylix
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
      # Standard Config Settings
      time.timeZone = "America/New_York";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      nexos.performance = {
        kernel = "performance";
        cachyosKernelCache = true;
      };
    };
}
