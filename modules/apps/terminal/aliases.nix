{ inputs, ... }:
{
  flake.nixosModules.aliases =
    { ... }:
    {
      environment.shellAliases = {
        l = "ls -lh --color=auto";
        c = "clear";
        disk = "lsblk -f";
        ff = "fastfetch";
        nit = "nitch";
        code = "codium";
        nrs = "nh os switch";
        nrb = "nh os build";
      };
    };
}
