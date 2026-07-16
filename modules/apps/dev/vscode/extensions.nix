{ inputs, ... }:
{
  flake.nixosModules.vscode-extensions =
    {
      pkgs,
      username,
      ...
    }:
    let
      jetVscodeExtension = pkgs.vscode-utils.buildVscodeExtension {
        pname = "jet-lang-jet";
        version = "0.1.0";
        src = inputs.jetlang + "/editors/vscode";
        sourceRoot = "vscode";

        npmDeps = pkgs.importNpmLock {
          npmRoot = inputs.jetlang + "/editors/vscode";
        };
        nativeBuildInputs = [
          pkgs.nodejs
          pkgs.importNpmLock.npmConfigHook
        ];

        vscodeExtUniqueId = "jet-lang.jet";
        vscodeExtPublisher = "jet-lang";
        vscodeExtName = "jet";
      };
    in
    {
      home-manager.users.${username} = {
        programs.vscodium.profiles.default = {
          extensions =
            with pkgs.vscode-extensions;
            [
              ## Languages
              jnoortheen.nix-ide
              arrterian.nix-env-selector
              github.copilot-chat
              github.vscode-pull-request-github
              # openai.chatgpt
              rust-lang.rust-analyzer
              # ms-python.python
              llvm-vs-code-extensions.vscode-clangd
              # ziglang.vscode-zig
              tamasfe.even-better-toml
              golang.go
              ms-vscode.cmake-tools
              llvm-vs-code-extensions.vscode-clangd
              pkgs.vscode-marketplace.anthropic.claude-code
              jetVscodeExtension
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                publisher = "openai";
                name = "chatgpt";
                version = "26.5707.31428";
                sha256 = "sha256-CFgMcUG/gczHZXn/vy1CD2ihwUxS66Cu3YSZsTJ0SkA=";
              }
            ];
        };
      };
    };
}
