{ inputs, ... }:
{
  flake.nixosModules.claude =
    { pkgs-unstable, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs-unstable.claude-code ];
      };
    };
}
