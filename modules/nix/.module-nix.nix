{ self, ... }:
{
  flake.nixosModules.nix =
    { ... }:
    {
      imports = [
        self.nixosModules.nh
        self.nixosModules.nixpkgs
        self.nixosModules.substituters
      ];
    };
}
