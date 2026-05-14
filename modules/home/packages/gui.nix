{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [

      ## Communication
      discord

      ## Browser
      librewolf
      vivaldi

      ## Office
      onlyoffice-desktopeditors
      thunderbird-bin

      ## Utility
      gparted
    ];
  };
}
