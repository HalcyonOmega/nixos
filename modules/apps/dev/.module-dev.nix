{ inputs, self, ... }:
{
  flake.nixosModules.dev =
    {
      pkgs,
      pkgs-unstable,
      username,
      ...
    }:
    {
      imports = [
        self.nixosModules.claude
        self.nixosModules.codex
        self.nixosModules.cursor
        self.nixosModules.devenv
        self.nixosModules.jetlang
        self.nixosModules.nixd
        self.nixosModules.node
        self.nixosModules.oh-my-pi
        # self.nixosModules.odysseus
        self.nixosModules.vscode
        self.nixosModules.zed
      ];

      home-manager.users.${username} = {
        home.packages = [
          pkgs.python3
          pkgs-unstable.pi-coding-agent
          pkgs-unstable.opencode
          pkgs-unstable.t3code
        ];
      };

    };
}
