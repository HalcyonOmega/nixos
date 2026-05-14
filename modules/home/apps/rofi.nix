{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [ pkgs.rofi ];
  };

  programs.rofi = {
    enable = true;
    theme = "sidebar";
    font = "sans-serif";
    package = pkgs.rofi;
    modes = [
      "drun"
      "run"
      "window"
      "ssh"
    ];
    extraConfig = {
      show-icons = true;
    };
  };
}
