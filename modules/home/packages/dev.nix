{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      ## Lsp
      nixd # nix

      ## C / C++
#       gcc
#       gdb
#       cmake
#
#       ncurses

      ## Python
#       python3

      ## Docker
#       docker
#       docker-buildx

      # Windows partition support
#       ntfs3g
#
#       appimage-run
#       power-profiles-daemon

        github-desktop
    ];
  };
}
