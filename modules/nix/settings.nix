{ inputs, ... }:
{
  flake.nixosModules.settings =
    { username, ... }:
    {
      # Disk-backed scratch for nix-daemon builds so large parallel compiles do
      # not fill the /tmp tmpfs (SIGBUS / desktop crashes) while leaving /tmp
      # itself on tmpfs for a live session.
      systemd.tmpfiles.rules = [ "d /var/tmp/nix-build 0755 root root -" ];

      nix = {
        settings = {
          # ext4 caps one inode at 65,000 hardlinks. Common tiny files can hit
          # that ceiling and make every build retry the same failed dedup.
          auto-optimise-store = false;
          build-dir = "/var/tmp/nix-build";
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          allowed-users = [ "${username}" ];
        };
      };
    };
}
