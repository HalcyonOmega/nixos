{ inputs, ... }:
{
  flake.nixosModules.brave-origin =
    {
      pkgs,
      username,
      ...
    }:
    let
      braveOrigin = inputs.brave-origin.packages.${pkgs.system}.default;
    in
    {
      home-manager.users.${username} = {
        home.packages = [ braveOrigin ];

        home.shellAliases = {
          brave-origin = "brave-origin-beta";
        };
      };
    };
}
