{ inputs, self, ... }:
{
  flake.nixosModules.dev =
    {
      lib,
      pkgs,
      pkgs-unstable,
      username,
      ...
    }:
    let
      kimiVersion = "0.29.0";
      kimiCode = pkgs.stdenvNoCC.mkDerivation {
        pname = "kimi-code";
        version = kimiVersion;

        src = pkgs.fetchurl {
          url = "https://github.com/MoonshotAI/kimi-code/releases/download/%40moonshot-ai%2Fkimi-code%40${kimiVersion}/kimi-code-linux-x64.zip";
          hash = "sha256-uyULVBEbB1sDKXybLmZ9hSRczXaMzmoboEUn/RPYQgA=";
        };

        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.unzip
        ];
        buildInputs = [ pkgs.stdenv.cc.cc.lib ];
        dontStrip = true;

        unpackPhase = ''
          runHook preUnpack
          unzip "$src"
          runHook postUnpack
        '';

        installPhase = ''
          runHook preInstall
          install -Dm755 kimi "$out/bin/kimi"
          runHook postInstall
        '';

        meta = {
          description = "Official Kimi Code terminal coding agent";
          homepage = "https://github.com/MoonshotAI/kimi-code";
          license = lib.licenses.mit;
          mainProgram = "kimi";
          platforms = [ "x86_64-linux" ];
          sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        };
      };
    in
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
          kimiCode
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
