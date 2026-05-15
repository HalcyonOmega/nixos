{
  pkgs,
  username,
  inputs,
  ...
}:

{

  home-manager.users.${username} = {
    home.packages = [ inputs.stylix ];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      image = /home/nate/nixos/assets/wallpapers/nixos/nixos_blue.png;

    };
  };
}
