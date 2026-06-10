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
        ody = "odysseus";
        nit = "nitch";
        code = "codium";
        nrs = "nh os switch";
        nrb = "nh os build";
        refresh = "nrs";
        update = "nix flake update";
        build = "nh os build";
        clean = "nh clean all && nix store optimise";
        build_iso = "nix run nixpkgs#nixos-generators -- --format iso --flake ~/nixos#iso -o result";
        zed = "zeditor";
        nixos = "code ~/nixos";
        de = "devenv shell";
        shell = "devenv shell";
      };
    };
}
