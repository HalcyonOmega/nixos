{ inputs, ... }:
{
  flake.nixosModules.boot =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
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
      };

      config = {
        boot = {
          kernelPackages = kernelPackages.${config.nexos.performance.kernel};
          loader = {
            efi.canTouchEfiVariables = true;
            limine = {
              enable = true;
              biosSupport = true;
              maxGenerations = 10;

              # style = {
              #   backdrop = "7EBAE4";
              # };
            };
            # systemd-boot.enable = true;
            # systemd-boot.configurationLimit = 5;
          };
          initrd = {
            systemd.enable = true;
            verbose = false;
          };
          supportedFilesystems = [
            "btrfs"
            "xfs"
            "ext4"
          ];
          consoleLogLevel = 0;
          kernelParams = [
            "quiet"
            "loglevel=0"
            "systemd.show_status=false"
            "rd.udev.log_level=3"
            "vt.global_cursor_default=0"
            "plymouth.use-simpledrm"
            "splash"
          ];
          plymouth = {
            enable = true;
            theme = lib.mkForce "hexagon_dots";
            logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake.png";
            themePackages = [
              (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "hexagon_dots" ]; })
            ];
          };
          tmp = {
            useTmpfs = true;
            cleanOnBoot = true;
          };
          zfs.forceImportRoot = false;
        };
      };
    };
}
