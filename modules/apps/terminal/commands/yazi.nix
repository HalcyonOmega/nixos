{ inputs, ... }:
{
  flake.nixosModules.yazi =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.yazi
        ];
      };
    };
}
