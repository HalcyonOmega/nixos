{ inputs, ... }:
{
  flake.nixosModules.odysseus =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.odysseus ];
      };
    };
}
