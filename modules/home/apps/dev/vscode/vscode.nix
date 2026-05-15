{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    programs.vscodium = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}