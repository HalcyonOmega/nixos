{ inputs, self, ... }:
{
  flake.nixosModules.apps =
    { ... }:
    {
      imports = [
        self.nixosModules.dev
        self.nixosModules.gaming
        self.nixosModules.general
        self.nixosModules.terminal
        self.nixosModules.utilities
        self.nixosModules.flatpak
      ];
    };
}
