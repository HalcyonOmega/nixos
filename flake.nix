{
  description = "My NixOS Flake Configuration";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nur.url = "github:nix-community/NUR";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord.url = "github:kaylorben/nixcord";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    ghostty.url = "github:ghostty-org/ghostty";

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      stylix,
      ...
    }@inputs:
    let
      username = "nate";
      system = "x86_64-linux";
      githubUsername = "HalcyonOmega";
      githubEmail = "nathanbrown@me.com";
      commonArgs = {
        inherit
          self
          inputs
          username
          system
          githubUsername
          githubEmail
          ;
      };
    in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = with inputs; [
            ./hosts/laptop
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.sharedModules = [
                plasma-manager.homeModules.plasma-manager
                nixcord.homeModules.nixcord
                nix-flatpak.homeManagerModules.nix-flatpak
              ];
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  username
                  githubEmail
                  githubUsername
                  ;
                host = "laptop";
              };
              home-manager.users.${username} = {
                home.stateVersion = "25.11";
              };
            }
          ];
          specialArgs = commonArgs // {
            host = "laptop";
          };
        };

        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = with inputs; [
            ./hosts/desktop
            # stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.sharedModules = [
                plasma-manager.homeModules.plasma-manager
                nixcord.homeModules.nixcord
                nix-flatpak.homeManagerModules.nix-flatpak
                vicinae.homeManagerModules.default
              ];
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  username
                  githubEmail
                  githubUsername
                  ;
                host = "desktop";
              };
              home-manager.users.${username} = {
                home.stateVersion = "25.11";
              };
            }
          ];
          specialArgs = commonArgs // {
            host = "desktop";
          };
        };

        ISO = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/iso/configuration.nix
          ];
        };
      };
    };
}
