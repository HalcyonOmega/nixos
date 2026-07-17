{ inputs, self, ... }:
{
  flake.nixosModules.dev =
    { pkgs-unstable, username, ... }:
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

      home-manager.users.${username} = {
        home.packages = [
          pkgs-unstable.opencode
          pkgs-unstable.t3code
        ];

        xdg.configFile."opencode/opencode.jsonc" = {
          force = true;
          text = builtins.toJSON {
            "$schema" = "https://opencode.ai/config.json";
            autoupdate = false;
            model = "kimi-for-coding-oauth/k3";
            provider."kimi-for-coding-oauth" = {
              name = "Kimi Code";
              npm = "@ai-sdk/openai-compatible";
              options.baseURL = "https://api.kimi.com/coding/v1";
              models.k3 = {
                name = "Kimi K3";
                attachment = true;
                reasoning = true;
                tool_call = true;
                limit = {
                  context = 262144;
                  output = 65536;
                };
                modalities = {
                  input = [
                    "text"
                    "image"
                  ];
                  output = [ "text" ];
                };
              };
            };
          };
        };
      };
    };
}
