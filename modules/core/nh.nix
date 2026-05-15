{ pkgs, username, ... }:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = "/home/${username}/nixos";
  };

  environment.systemPackages = [
    pkgs.nix-output-monitor
    pkgs.nvd
    pkgs.nixfmt
  ];
}
