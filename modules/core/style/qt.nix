{ inputs, ... }:
{
  flake.nixosModules.qt =
    { pkgs, username, ... }:
    {
        #qt = {
        #  enable = true;
        #  platformTheme.name = "gtk2";
        #  style = "gtk2";
        #};
      #home-manager.users.${username} = {
      #};
    };
}
