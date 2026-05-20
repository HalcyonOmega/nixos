{ inputs, ... }:
{
  flake.nixosModules.gtk =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        gtk.gtk2.force = true;
        xdg.configFile."gtk-3.0/settings.ini".force = true;
        xdg.configFile."gtk-4.0/settings.ini".force = true;
      };
    };
}
