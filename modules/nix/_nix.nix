{ self, ... }:
{
  flake.nixosModules.nix =
    { ... }:
    {
      imports = [
        self.nixosModules.nixpkgs
      ];
    };
}
