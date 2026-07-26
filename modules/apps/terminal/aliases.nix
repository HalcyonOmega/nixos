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
        cpa = "cli-proxy-api -config ~/.cli-proxy-api/config.yaml";
        nrs = "nh os switch";
        # One-time bootstrap after build-dir moved off /var/tmp (Nix rejects world-writable parents).
        nrs-bootstrap = "sudo install -d -m 0755 /var/cache/nix-build && nh os switch -- --option build-dir /var/cache/nix-build";
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
        dev = "nex develop";
      };
    };
}
