{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Plasma beta releases generally land on master before they reach
    # nixos-unstable. Use this only through the dedicated test configuration.
    nixpkgs-plasma-beta.url = "github:NixOS/nixpkgs/master";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    ghostty.url = "github:ghostty-org/ghostty";

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    brave-origin = {
      url = "github:clementpoiret/brave-origin-flake";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    helium-flake.url = "github:oxcl/nix-flake-helium-browser";
    helium-flake.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      username = "nate";
      system = "x86_64-linux";
      githubUsername = "HalcyonOmega";
      githubEmail = "nathanbrown@me.com";
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      commonArgs = {
        inherit
          self
          inputs
          username
          system
          githubUsername
          githubEmail
          pkgs-stable
          ;
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.import-tree ./modules)
      ];

      _module.args = commonArgs // {
        inherit commonArgs;
      };
    };
}
