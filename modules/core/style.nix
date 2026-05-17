{ inputs, ... }:
{
  flake.nixosModules.style =
    {
      pkgs,
      config,
      username,
      inputs,
      ...
    }:

    let
      opacity = 0.95;
      fontSize = 11;
    in
    {
      stylix = {
        enable = true;
        image = ./../../assets/wallpapers/vortex.jpg;
        polarity = "dark";

        # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
        # base16Scheme = {
        #   system = "base16";
        #   name = "selenized-black";
        #   author = "Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali";
        #   variant = "dark";

        #   palette = {
        #     base00 = "181818";
        #     base01 = "252525";
        #     base02 = "3b3b3b";
        #     base03 = "777777";
        #     base04 = "777777";
        #     base05 = "b9b9b9";
        #     base06 = "dedede";
        #     base07 = "dedede";
        #     base08 = "ed4a46";
        #     base09 = "e67f43";
        #     base0A = "dbb32d";
        #     base0B = "70b433";
        #     base0C = "3fc5b7";
        #     base0D = "368aeb";
        #     base0E = "a580e2";
        #     base0F = "eb6eb7";
        #   };
        # };

        opacity = {
          terminal = opacity;
          popups = opacity;
        };

        cursor = {
          package = pkgs.phinger-cursors;
          name = "phinger-cursors";
          size = 24;
        };

        fonts = {
          # serif = {
          #   package = pkgs.aleo-fonts;
          #   name = "Aleo";
          # };
          serif = config.stylix.fonts.sansSerif;

          sansSerif = {
            package = pkgs.atkinson-hyperlegible-next;
            name = "Atkinson Hyperlegible Next";
          };

          monospace = {
            package = pkgs.atkinson-hyperlegible-mono;
            name = "Atkinson Hyperlegible Mono";
          };

          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };

          sizes = {
            applications = fontSize;
            desktop = fontSize;
            popups = fontSize;
            terminal = fontSize;
          };
        };
      };
    };
}
