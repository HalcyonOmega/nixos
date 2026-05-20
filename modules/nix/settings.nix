{ inputs, ... }:
{
  flake.nixosModules.settings =
    { username, ... }:
    {
      nix = {
        settings = {
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          allowed-users = [ "${username}" ];
        };
      };
    };
}
