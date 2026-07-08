{ inputs, ... }:
{
  flake.nixosModules.codex =
    {
      inputs,
      system,
      username,
      pkgs-unstable,
      ...
    }:
    {
      home-manager.users.${username} = {
        # codex CLI tracks nixpkgs-unstable; bump via `nix flake update nixpkgs-unstable`.
        home.packages = [
          pkgs-unstable.codex
          inputs.codex-desktop-linux.packages.${system}.codex-desktop-computer-use-ui-remote-mobile-control
        ];
      };
    };
}
