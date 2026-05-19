{ inputs, ... }:
{
  flake.nixosModules.gtk =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        # gtk = {
        #   enable = true;

        #   theme = {
        #     name = "Breeze-Dark";
        #     package = pkgs.kdePackages.breeze-gtk;
        #   };

        #   iconTheme = {
        #     name = "breeze-dark";
        #     package = pkgs.kdePackages.breeze-icons;
        #   };

        #   cursorTheme = {
        #     name = "Phinger Cursors (dark)";
        #     package = pkgs.phinger-cursors;
        #     size = 24;
        #   };

        #   font = {
        #     name = "Atkinson Hyperlegible Next";
        #     size = 12;
        #   };

        #   gtk2.force = true;

        #   gtk3.extraConfig = {
        #     gtk-application-prefer-dark-theme = true;
        #   };

        #   gtk4.extraConfig = {
        #     gtk-application-prefer-dark-theme = true;
        #   };
        # };

        # dconf.settings."org/gnome/desktop/interface" = {
        #   color-scheme = "prefer-dark";
        #   gtk-theme = "Breeze-Dark";
        #   icon-theme = "breeze-dark";
        #   cursor-theme = "Phinger Cursors (dark)";
        # };

        xdg.configFile."gtk-3.0/settings.ini".force = true;
        xdg.configFile."gtk-4.0/settings.ini".force = true;
      };
    };
}
