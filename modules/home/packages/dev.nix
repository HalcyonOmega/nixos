{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [
      ## LSP
      pkgs.nixd # Nix

      pkgs.github-desktop
    ];
  };
}
