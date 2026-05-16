{ inputs, ... }:
{
  flake.nixosModules.stylix =
    {
      pkgs,
      username,
      inputs,
      ...
    }:
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
        image = ./../../assets/wallpapers/firewatch_dark.png;

      };
    };
}
