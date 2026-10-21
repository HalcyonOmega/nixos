{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Keep Handy current without upgrading the other unstable applications.
    nixpkgs-handy.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Plasma 6.7+ lands on master before nixos-unstable. Use only via
    # halcyon-plasma-beta until it reaches the stable channel inputs.
    nixpkgs-plasma-beta.url = "github:NixOS/nixpkgs/master";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nur.url = "github:nix-community/NUR";

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
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
      inputs.nixpkgs.follows = "nixpkgs";
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

    nexos = {
      url = "github:HalcyonOmega/nexos/dev";
      inputs.nexpkgs.follows = "nixpkgs";
    };

    jetlang.url = "git+file:///home/nate/Projects/Github/jet";

    # Helios (Sunshine fork): per-session KDE virtual displays, per-app audio, Steam library import.
    helios = {
      url = "git+file:///home/nate/Projects/Github/helios";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Codex CLI from OpenAI's official prebuilt release binaries; tracks the
    # latest release faster than nixpkgs. Bump via `nix flake update codex-cli-nix`.
    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix/main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    claude-code-nix = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Oh My Pi (omp) coding agent harness. omp-flake supplies the Home Manager
    # module; the package is built from the upstream source tag below so local
    # patches (modules/apps/dev/patches/omp-*.patch) apply. Bump by editing the tag.
    omp-flake = {
      url = "github:cernoh/omp-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    oh-my-pi = {
      url = "github:can1357/oh-my-pi/v18.12.5";
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
      githubEmail = "129798039+HalcyonOmega@users.noreply.github.com";
      pkgs-unstable = import inputs.nixpkgs-unstable {
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
          pkgs-unstable
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
