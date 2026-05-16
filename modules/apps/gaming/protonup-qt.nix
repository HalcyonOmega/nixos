{ inputs, ... }:
{
  flake.nixosModules.protonup-qt =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.protonup-qt ];
      };
    };
}
