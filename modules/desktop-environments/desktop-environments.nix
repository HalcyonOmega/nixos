{ inputs, self, ... }:
{
  flake.nixosModules.desktop-environments = {
    imports = [
      self.nixosModules.kde
    ];
  };
}
