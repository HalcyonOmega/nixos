{ inputs, self, ... }:
{
  flake.nixosModules.terminal =
    { ... }:
    {
      imports = [
        self.nixosModules.commands
        self.nixosModules.shells
        self.nixosModules.aliases
        self.nixosModules.ghostty
        self.nixosModules.shell
      ];
    };
}
