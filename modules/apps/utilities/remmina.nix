{ inputs, ... }:
{
  flake.nixosModules.remmina =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.remmina ];
      };
    };
}
