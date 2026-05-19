{ inputs, self, ... }:
{
  flake.nixosModules.utilities =
    { ... }:
    {
      imports = [
        self.nixosModules.bitwarden
        self.nixosModules.gparted
        self.nixosModules.localsend
        self.nixosModules.solaar
        self.nixosModules.streamcontroller
        self.nixosModules.vicinae
      ];
    };
}
