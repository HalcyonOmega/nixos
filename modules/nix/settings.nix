{ inputs, ... }:
{
  flake.nixosModules.settings =
    { username, ... }:
    {
      nix = {
        settings = {
          # ext4 caps one inode at 65,000 hardlinks. Common tiny files can hit
          # that ceiling and make every build retry the same failed dedup.
          auto-optimise-store = false;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          allowed-users = [ "${username}" ];
        };
      };
    };
}
