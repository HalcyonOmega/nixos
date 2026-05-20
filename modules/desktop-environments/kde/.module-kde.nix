{ inputs, self, ... }:
{
  flake.nixosModules.kde = {
    imports = [
      self.nixosModules.plasma-manager
    ];
  };
}
