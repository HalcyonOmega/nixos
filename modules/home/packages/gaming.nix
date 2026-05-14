{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [
      ## Utils
      pkgs.gamemode

      # Enable mangohud & goverlay for stats/metrics overlay on games
      # pkgs.mangohud
      # pkgs.goverlay

      pkgs.wine
      pkgs.winetricks
      pkgs.protontricks
      pkgs.protonup-qt
      # inputs.nix-gaming.packages.${pkgs.system}.wine-ge

      # mouse setup
      # piper

      ## Emulation
      # sameboy
      # snes9x
      # yuzu
      # dolphin-emu
      # retroarch-free
    ];
  };
}
