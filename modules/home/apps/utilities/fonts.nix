{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    fonts.fontconfig.enable = true;
    home.packages = [
      pkgs.nerd-fonts.noto
      pkgs.noto-fonts-cjk-serif
      pkgs.noto-fonts-cjk-sans
      pkgs.texlivePackages.symbol
    ];
  };
}
