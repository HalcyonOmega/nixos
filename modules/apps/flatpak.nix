{ inputs, ... }:
{
  flake.nixosModules.flatpak =
    {
      inputs,
      ...
    }:
    let
      desiredFlatpaks = [
        "com.github.tchx84.Flatseal"
        "com.spotify.Client"
        "io.github.unknownskl.greenlight"
      ];
    in
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak = {
        enable = true;
        packages = desiredFlatpaks;
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
