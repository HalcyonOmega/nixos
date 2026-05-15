{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [
      pkgs.fish
    ];

    programs.fish.enable = true;
  };
}
