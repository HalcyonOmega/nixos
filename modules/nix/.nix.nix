{ self, ... }:
{
  flake.nixosModules.nix =
    { ... }:
    {
      imports = [
        self.nixosModules.nixpkgs
        self.nixosModules.substituters
      ];
    };
}
