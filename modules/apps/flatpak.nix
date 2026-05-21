{ inputs, ... }:
{
  flake.nixosModules.flatpak =
    { inputs, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak = {
        enable = true;
        packages = [
          "com.github.tchx84.Flatseal"
          "io.github.everestapi.Olympus"
          "io.github.unknownskl.greenlight"
        ];
        overrides = {
          global = {
            Context.sockets = [
              "wayland"
              "!x11"
              "!fallback-x11"
            ];
          };
        };
      };
    };
}
