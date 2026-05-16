{ inputs, ... }:
{
  flake.nixosModules.fresh =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.fresh-editor
        ];
      };
    };
}
