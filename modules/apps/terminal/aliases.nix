{ inputs, ... }:
{
  flake.nixosModules.aliases =
    { ... }:
    {
      environment.shellAliases = {
        l = "eza -l --no-user --no-permissions --group-directories-first";
        c = "clear";
        disk = "lsblk -f";
        ff = "fastfetch";
        nit = "nitch";
        code = "codium";
        nrs = "nh os switch";
        nrb = "nh os build";
        update = "nrs";
        upgrade = "nix flake update";
        build = "nh os build";
        clean = "nh clean all";
      };
    };
}
