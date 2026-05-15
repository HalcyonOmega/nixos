{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [
      ## Nix LSP
      pkgs.nixd

    ];
  };
}
