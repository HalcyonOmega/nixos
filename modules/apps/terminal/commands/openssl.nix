{ inputs, ... }:
{
  flake.nixosModules.openssl =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.openssl
        ];
      };
    };
}
