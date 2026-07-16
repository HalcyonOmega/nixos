{ inputs, self, ... }:
{
  flake.nixosModules.dev =
    { ... }:
    {
      imports = [
        self.nixosModules.claude
        self.nixosModules.codex
        self.nixosModules.cursor
        self.nixosModules.devenv
        self.nixosModules.jetlang
        self.nixosModules.nixd
        self.nixosModules.node
        # self.nixosModules.odysseus
        self.nixosModules.vscode
        self.nixosModules.zed
      ];
    };
}
