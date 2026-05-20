{ inputs, ... }:
{
  flake.nixosModules.nixhelper =
    { pkgs, username, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 5";
        };
        flake = "/home/${username}/nexos";
      };

      environment.systemPackages = [
        pkgs.nix-output-monitor
        pkgs.nvd
        pkgs.nixfmt
      ];
    };
}
