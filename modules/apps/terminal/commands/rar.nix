{ inputs, ... }:
{
  flake.nixosModules.rar =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.rar
        ];
      };
    };
}
