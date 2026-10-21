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
            inputs.helium-flake.overlays.default
            inputs.nix-vscode-extensions.overlays.default
          ];
          config.permittedInsecurePackages = [
            "electron-40.10.5"
          ];
        };
      };
    };
}
