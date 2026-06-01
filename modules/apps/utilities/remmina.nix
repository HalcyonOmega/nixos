{ inputs, ... }:
{
  # Remote Desktop Client
  flake.nixosModules.remmina =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.remmina ];
      };
    };
}
