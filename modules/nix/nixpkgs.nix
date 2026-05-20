{ inputs, ... }:
{
  flake.nixosModules.nixpkgs =
    { inputs, ... }:
    {
      config = {
        nixpkgs = {
          config.allowUnfree = true;
          overlays = [
            inputs.nur.overlays.default
            inputs.nix-cachyos-kernel.overlays.default
          ];
        };
      };
    };
}
