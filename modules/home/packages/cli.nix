{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    programs.mpv = {
      enable = true;
      package = (
        pkgs.mpv-unwrapped.wrapper {
          scripts = with pkgs.mpvScripts; [
            uosc
            sponsorblock
          ];
          mpv = pkgs.mpv-unwrapped.override {
            waylandSupport = true;
          };
        }
      );
      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      };
    };

    home.packages = with pkgs; [
      # Better Core Utils
      bat
      ripgrep # Grep Replacement
      tldr
      eza
      fzf
      zoxide
      yazi

      # Monitoring / Fetch
      btop
      nitch # Nix Fastfetch
      rar

      # Fun / Screensaver
      cmatrix

      # Command history
      # atuin

      # Utilities
      # yt-dlp-light
      # ffmpeg
      # killall
      openssl
      # pamixer # pulseaudio command line mixer
      # unzip
      # wget
      # xdg-utils
      # mlocate
    ];
  };
}
