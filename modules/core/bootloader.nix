{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 5;
    };
    initrd.systemd.enable = true;
    initrd.verbose = false;
    supportedFilesystems = [ "ntfs" ];
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
      theme = "deus_ex";
      logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake.png";
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "deus_ex" ]; })
      ];
    };
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };
}