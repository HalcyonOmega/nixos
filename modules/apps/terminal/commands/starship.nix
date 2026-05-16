{ inputs, ... }:
{
  flake.nixosModules.starship =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.starship
        ];
      };
    };
}
