{ self, ... }:
{
  flake.nixosModules.nix =
    { ... }:
    {
      imports = [
        self.nixosModules.home-manager
        self.nixosModules.nixhelper
        self.nixosModules.nixpkgs
        self.nixosModules.settings
        self.nixosModules.substituters
      ];
    };
}
