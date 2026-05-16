{ inputs, ... }:
{
  flake.nixosModules.nixd =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        # Nix LSP
        home.packages = [ pkgs.nixd ];
      };
    };
}
