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
        nix = {
          settings = {
            auto-optimise-store = true;
            experimental-features = [
              "nix-command"
              "flakes"
            ];
          };
        };

        boot.kernelPackages = kernelPackages.${cfg.kernel};
        system.stateVersion = "26.11";
      };
    };
}
