{ inputs, ... }:
{
  flake.nixosModules.system =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    let
      cfg = config.nexos.performance;

      kernelPackages = {
        safe = pkgs.linuxPackages_zen;
        lts = pkgs.cachyosKernels.linuxPackages-cachyos-lts;
        performance = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
      };
    in
    {
      options.nexos.performance = {
        kernel = lib.mkOption {
          type = lib.types.enum (builtins.attrNames kernelPackages);
          default = "safe";
          description = ''
            Kernel profile to boot: safe uses Zen, lts uses CachyOS LTS, and performance uses CachyOS latest.
          '';
        };

        cachyosKernelCache = lib.mkEnableOption "the nix-cachyos-kernel binary cache";
      };

      config = {
        # imports = [ inputs.nix-gaming.nixosModules.default ];
        nix = {
          settings = {
            auto-optimise-store = true;
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            substituters = [
              "https://nix-community.cachix.org"
              "https://nix-gaming.cachix.org"
              "https://hyprland.cachix.org"
              "https://ghostty.cachix.org"
              "https://ezkea.cachix.org"
            ] ++ lib.optionals cfg.cachyosKernelCache [
              "https://attic.xuyh0120.win/lantian"
              "https://cache.garnix.io"
            ];
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
              "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
              "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
            ] ++ lib.optionals cfg.cachyosKernelCache [
              "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
              "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            ];
          };
        };

        nixpkgs = {
          overlays = [
            inputs.nur.overlays.default
            inputs.nix-cachyos-kernel.overlays.default
          ];
          config.allowUnfree = true;
        };

        boot.kernelPackages = kernelPackages.${cfg.kernel};
        system.stateVersion = "26.11";
      };
    };
}
