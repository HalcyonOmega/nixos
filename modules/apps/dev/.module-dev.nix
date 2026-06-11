{ inputs, self, ... }:
{
  flake.nixosModules.dev =
    { ... }:
    {
      imports = [
        self.nixosModules.cursor
        self.nixosModules.devenv
        self.nixosModules.lexlang
        self.nixosModules.nixd
        # self.nixosModules.odysseus
        self.nixosModules.vscode
        self.nixosModules.zed
      ];
    };
}
