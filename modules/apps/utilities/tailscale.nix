{ inputs, ... }:
{
  flake.nixosModules.tailscale =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.tailscale
          pkgs.cifs-utils
        ];
      };

      services.tailscale.enable = true;

      fileSystems."/home/${username}/Storehouse" = {
        device = "//100.111.245.62/Storehouse";
        fsType = "cifs";
        options = [
          "credentials=/etc/samba/credentials/storehouse"
          "uid=${username}"
          "gid=users"
          "file_mode=0664"
          "dir_mode=0775"
          "iocharset=utf8"
          "noperm"
          "vers=3.0"
          "x-systemd.automount"
          "x-systemd.idle-timeout=60"
          "noauto"
          "nofail"
          "_netdev"
          "x-systemd.requires=tailscaled.service"
          "x-systemd.after=tailscaled.service"
        ];
      };

      systemd.tmpfiles.rules = [
        "d /etc/samba/credentials 0700 root root -"
      ];
    };
}
