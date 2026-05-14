{ pkgs, username, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    displayManager.sddm.enable = true;
    displayManager.sddm.settings.General.DisplayServer = "wayland";
    displayManager.sddm.wayland.enable = true;
    desktopManager.plasma6.enable = true;
  };

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs.kdePackages; [
    xdg-desktop-portal-kde
    kcalc
    breeze-icons
    # kdenlive
    filelight
    plasma-browser-integration
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
  ];
}
