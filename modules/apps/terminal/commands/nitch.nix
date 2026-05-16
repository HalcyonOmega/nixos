{ inputs, ... }:
{
  flake.nixosModules.nitch =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.nitch
        ];
      };
    };
}
