{ pkgs, username, ... }:
{
  programs.fish.enable = true;

  home-manager.users.${username} = {
    home.packages = [
      pkgs.fish
    ];

  };
}
