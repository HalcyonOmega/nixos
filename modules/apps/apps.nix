{ inputs, self, ... }:
{
  flake.nixosModules.apps =
    { ... }:
    {
      imports = [
        self.nixosModules.terminal
      ];
    };
}
