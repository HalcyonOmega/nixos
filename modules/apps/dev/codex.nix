{ inputs, ... }:
{
  flake.nixosModules.codex =
    { pkgs-unstable, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs-unstable.codex ];
      };
    };
}
