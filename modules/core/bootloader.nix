{ inputs, ... }:
{
  flake.nixosModules.bootloader =
    { pkgs, lib, ... }:
    # let
    #   cfg = config.nexos.performance;

    #   kernelPackages = {
    #     safe = pkgs.linuxPackages_zen;
    #     lts = pkgs.cachyosKernels.linuxPackages-cachyos-lts;
    #     performance = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    #   };
    # in
    {
      boot = {
        # options.nexos.performance = {
        #   kernel = lib.mkOption {
        #     type = lib.types.enum (builtins.attrNames kernelPackages);
        #     default = "safe";
        #     description = ''
        #       Kernel profile to boot: safe uses Zen, lts uses CachyOS LTS, and performance uses CachyOS latest.
        #     '';
        #   };

        #   cachyosKernelCache = lib.mkEnableOption "the nix-cachyos-kernel binary cache";
        # };
        # config = {
        #   boot.kernelPackages = kernelPackages.${cfg.kernel};
        # };
        kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

        loader = {
          efi.canTouchEfiVariables = true;
          limine.enable = true;
          # systemd-boot.enable = true;
          # systemd-boot.configurationLimit = 5;
        };
        initrd.systemd.enable = true;
        initrd.verbose = false;
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
}
