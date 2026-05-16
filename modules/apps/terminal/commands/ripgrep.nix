{ inputs, ... }:
{
  flake.nixosModules.ripgrep =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.ripgrep
        ];
      };
    };
}
