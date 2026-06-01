{ inputs, self, ... }:
{
  flake.nixosModules.dev =
    { ... }:
    {
      imports = [
        self.nixosModules.cursor
        self.nixosModules.devenv
        self.nixosModules.nixd
        self.nixosModules.vscode
      ];
    };
}
