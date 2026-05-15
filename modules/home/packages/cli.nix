{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    # programs.mpv = {
    #   enable = true;
    #   package = (
    #     pkgs.mpv-unwrapped.wrapper {
    #       scripts = with pkgs.mpvScripts; [
    #         uosc
    #         sponsorblock
    #       ];
    #       mpv = pkgs.mpv-unwrapped.override {
    #         waylandSupport = true;
    #       };
    #     }
    #   );
    #   config = {
    #     profile = "high-quality";
    #     ytdl-format = "bestvideo+bestaudio";
    #     cache-default = 4000000;
    #   };
    # };

    home.packages = with pkgs; [
      # Better Core Utils
      # bat
      # ripgrep # Grep Replacement
      # tealdeer
      # eza
      # fzf
      # zoxide
      # yazi
      # starship

      # btop
      # nitch
      # rar
      # cmatrix
      # openssl
    ];
  };
}
