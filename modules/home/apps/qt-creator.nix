{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [
      pkgs.qtcreator
      pkgs.libGL
      pkgs.cmake
      pkgs.gcc
      pkgs.libigl
      pkgs.qt6.qtbase
      pkgs.qt6.qtdeclarative
    ];
  };
}
