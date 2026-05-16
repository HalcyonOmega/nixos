{ inputs, self, ... }:
{
  flake.nixosModules.terminal =
    { ... }:
    {
      imports = [
        self.nixosModules.commands
        self.nixosModules.shells
      ];
    };
}
