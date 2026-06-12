{ inputs, ... }:
{
  flake.nixosModules.cursor =
    {
      lib,
      pkgs,
      username,
      ...
    }:
    let
      jetRoot = "/home/${username}/Projects/Github/jet";
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

      # Cursor 3.2.x embeds VS Code 1.105; nixpkgs nix-ide 0.5.9 requires >=1.112 and is skipped.
      nixIde = pkgs.vscode-extensions.jnoortheen.nix-ide.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          substituteInPlace $out/share/vscode/extensions/jnoortheen.nix-ide/package.json \
            --replace-fail '"vscode": ">=1.112.0"' '"vscode": "^1.105.0"'
        '';
      });
    in
    {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          nixd
          nixfmt
        ];

        programs.cursor = {
          enable = true;
          package = pkgs.code-cursor;
          mutableExtensionsDir = false;
          profiles.default = {
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;
            extensions = with pkgs.vscode-extensions; [
              nixIde
              arrterian.nix-env-selector
              ms-vscode-remote.remote-containers
              pkgs.vscode-marketplace.anthropic.claude-code
              jetVscodeExtension
            ];
            userSettings = {
              "window.titleBarStyle" = "custom";
              "extensions.autoUpdate" = false;
              "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
              "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";

              "nix.serverPath" = lib.getExe pkgs.nixd;
              "nix.enableLanguageServer" = true;
              "nix.serverSettings" = {
                "nixd" = {
                  "formatting" = {
                    "command" = [ (lib.getExe pkgs.nixfmt) ];
                  };
                };
              };
            };
          };
        };
      };
    };
}
