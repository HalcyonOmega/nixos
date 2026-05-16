{ inputs, ... }:
{
  flake.nixosModules.zoxide =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.zoxide
        ];
      };
    };
}
