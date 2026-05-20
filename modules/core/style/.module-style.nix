{ inputs, self, ... }:
{
  flake.nixosModules.style =
    { ... }:
    {
      imports = [
        self.nixosModules.fonts
        self.nixosModules.gtk
        self.nixosModules.qt
        self.nixosModules.stylix
      ];
    };
}
