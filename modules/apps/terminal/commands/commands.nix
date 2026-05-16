{ inputs, self, ... }:
{
  flake.nixosModules.commands =
    { ... }:
    {
      imports = [
        self.nixosModules.bat
      ];
    };
}
