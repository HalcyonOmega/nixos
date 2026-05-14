{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      ## Utils
      gamemode
      mangohud
      goverlay
      wine
      winetricks
      protontricks
      protonup-qt
      # inputs.nix-gaming.packages.${pkgs.system}.wine-ge

      # mouse setup
      piper

      ## Emulation
      # sameboy
      # snes9x
      # yuzu
      # dolphin-emu
      # retroarch-free
    ];
  };
}
