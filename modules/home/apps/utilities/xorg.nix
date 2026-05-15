{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [
      pkgs.bibata-cursors
      pkgs.whitesur-icon-theme
      # Add X11 libraries for JavaFX and GUI applications
      pkgs.xorg.libX11
      pkgs.xorg.libXext
      pkgs.xorg.libXrender
      pkgs.xorg.libXtst
      pkgs.xorg.libXi
      pkgs.xorg.libXrandr
      pkgs.xorg.libXcursor
      pkgs.xorg.libXinerama
      pkgs.xorg.libXxf86vm
      # Additional libraries that JavaFX might need
      pkgs.freetype
      pkgs.fontconfig
      pkgs.alsa-lib
      pkgs.cairo
      pkgs.glib
      pkgs.gtk3
      pkgs.pango
      pkgs.zlib
    ];

    # Alternative xorg cursor configuration if needed
    home.pointerCursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 32;
      x11.enable = true;
    };

    # Set environment variables for JavaFX to find X11 libraries
    home.sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.xorg.libX11}/lib:${pkgs.xorg.libXext}/lib:${pkgs.xorg.libXrender}/lib:${pkgs.xorg.libXtst}/lib:${pkgs.xorg.libXi}/lib:${pkgs.xorg.libXrandr}/lib:${pkgs.xorg.libXcursor}/lib:${pkgs.xorg.libXinerama}/lib:${pkgs.xorg.libXxf86vm}/lib:${pkgs.freetype}/lib:${pkgs.fontconfig.lib}/lib:${pkgs.alsa-lib}/lib:${pkgs.cairo}/lib:${pkgs.glib.out}/lib:${pkgs.gtk3}/lib:${pkgs.pango}/lib:${pkgs.zlib}/lib";
      JAVA_LIBRARY_PATH = "${pkgs.xorg.libX11}/lib:${pkgs.xorg.libXext}/lib:${pkgs.xorg.libXrender}/lib";
    };
  };
}
