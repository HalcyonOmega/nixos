{ inputs, ... }:
{
  flake.nixosModules.thunderbird =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.thunderbird-bin ];
      };
    };
}
