{ inputs, ... }:
{
  flake.nixosModules.fzf =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.fzf
        ];
      };
    };
}
