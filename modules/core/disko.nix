{ ... }:
{
  flake.nixosModules.disko =
    { config, lib, ... }:
    {
      options.nexos.disko.device = lib.mkOption {
        type = lib.types.str;
        default = "/dev/nvme0n1";
        description = "Install target disk used by Disko for the host.";
      };

      config.disko.devices = {
        disk.main = {
          type = "disk";
          device = lib.mkDefault config.nexos.disko.device;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "fmask=0077"
                    "dmask=0077"
                  ];
                };
              };

              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "xfs";
                  mountpoint = "/";
                  mountOptions = [
                    "defaults"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
}
