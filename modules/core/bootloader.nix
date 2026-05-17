{ inputs, ... }:
{
  flake.nixosModules.bootloader =
    { pkgs, lib, ... }:
    {
      boot = {
        loader = {
          efi.canTouchEfiVariables = true;
          limine.enable = true;
          # systemd-boot.enable = true;
          # systemd-boot.configurationLimit = 5;
        };
        # initrd.systemd.enable = true;
        # initrd.verbose = false;
        supportedFilesystems = [
          "btrfs"
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
      };
    };
}
