{ inputs, ... }:
{
  flake.nixosModules.vscode-extensions =
    {
      pkgs,
      username,
      ...
    }:
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
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                publisher = "openai";
                name = "chatgpt";
                version = "latest";
                sha256 = "sha256-+VGA6KjQA7MttchkypFeIRKuehzHaABYPD01fo7dREM=";
              }
            ];
        };
      };
    };
}
