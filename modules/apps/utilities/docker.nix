{ inputs, ... }:
{
  flake.nixosModules.docker =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        # home.packages = [ ];
      };
    };
}
