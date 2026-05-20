{ inputs, ... }:
{
  flake.nixosModules.stylix =
    { ... }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        image = ../../../assets/wallpapers/mountain3.jpg;
        polarity = "dark";

        base16Scheme = ../../../assets/themes/reactor.yaml;

        #   opacity = {
        #     terminal = opacity;
        #     popups = opacity;
        #   };

        #   cursor = {
        #     package = pkgs.phinger-cursors;
        #     name = "phinger-cursors";
        #     size = 24;
        #   };

        #   fonts = {
        #     # serif = {
        #     #   package = pkgs.aleo-fonts;
        #     #   name = "Aleo";
        #     # };
        #     serif = config.stylix.fonts.sansSerif;

        #     sansSerif = {
        #       package = pkgs.atkinson-hyperlegible-next;
        #       name = "Atkinson Hyperlegible Next";
        #     };

        #     monospace = {
        #       package = pkgs.atkinson-hyperlegible-mono;
        #       name = "Atkinson Hyperlegible Mono";
        #     };

        #     emoji = {
        #       package = pkgs.noto-fonts-color-emoji;
        #       name = "Noto Color Emoji";
        #     };

        #     sizes = {
        #       applications = fontSize;
        #       desktop = fontSize;
        #       popups = fontSize;
        #       terminal = fontSize;
        #     };
        #   };
      };
    };
}
