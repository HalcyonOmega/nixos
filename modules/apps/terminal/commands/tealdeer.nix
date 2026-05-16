{ inputs, ... }:
{
  flake.nixosModules.tealdeer =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.tealdeer
        ];
      };
    };
}
