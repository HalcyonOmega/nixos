{ inputs, self, ... }:
{
  flake.nixosModules.dev =
    { ... }:
    {
      imports = [
        self.nixosModules.cursor
        self.nixosModules.devenv
        self.nixosModules.lapce
        self.nixosModules.nixd
        # self.nixosModules.odysseus
        self.nixosModules.vscode
        self.nixosModules.zed
      ];
    };
}
