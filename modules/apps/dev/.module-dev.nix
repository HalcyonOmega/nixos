{ inputs, self, ... }:
{
  flake.nixosModules.dev =
    { ... }:
    {
      imports = [
        self.nixosModules.cursor
        self.nixosModules.nixd
        self.nixosModules.vscode
      ];
    };
}
