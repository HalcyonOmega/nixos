{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    # @Nate - TODO: Consider using "Spicetify"
    home.packages = [ pkgs.spotify ];
  };
}
