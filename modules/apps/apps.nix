{ inputs, self, ... }:
{
  flake.nixosModules.apps =
    { ... }:
    {
      imports = [
        self.nixosModules.terminal
        self.nixosModules.flatpak
      ];
    };
}
