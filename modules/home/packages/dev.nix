{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [
      ## LSP
      pkgs.nixd # Nix

      #A/O 14 MAY, github-desktop doesn't load
      # pkgs.github-desktop
    ];
  };
}
