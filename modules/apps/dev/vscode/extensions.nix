{ inputs, ... }:
{
  flake.nixosModules.vscode-extensions =
    {
      pkgs,
      terminalTheme,
      username,
      ...
    }:
    # let
    #   colors = terminalTheme.colors;
    #   reactorThemeJson = builtins.toJSON {
    #     name = "Reactor";
    #     type = "dark";
    #     colors = {
    #       "activityBar.background" = colors.background;
    #       "activityBar.foreground" = colors.foreground;
    #       "activityBarBadge.background" = colors.cyan;
    #       "activityBarBadge.foreground" = colors.cursor-text;
    #       "badge.background" = colors.selection-background;
    #       "badge.foreground" = colors.foreground;
    #       "button.background" = colors.blue;
    #       "button.foreground" = colors.cursor-text;
    #       "button.hoverBackground" = colors.cyan;
    #       "editor.background" = colors.background;
    #       "editor.foreground" = colors.foreground;
    #       "editor.lineHighlightBackground" = colors.lineHighlight;
    #       "editor.selectionBackground" = colors.selection-background;
    #       "editorCursor.foreground" = colors.cursor-color;
    #       "editorGroupHeader.tabsBackground" = colors.background;
    #       "editorLineNumber.activeForeground" = colors.foreground;
    #       "editorLineNumber.foreground" = colors.comment;
    #       "input.background" = colors.lineHighlight;
    #       "input.foreground" = colors.foreground;
    #       "list.activeSelectionBackground" = colors.selection-background;
    #       "list.activeSelectionForeground" = colors.selection-foreground;
    #       "list.focusBackground" = colors.selection-background;
    #       "list.hoverBackground" = colors.lineHighlight;
    #       "panel.background" = colors.background;
    #       "panel.border" = colors.lineHighlight;
    #       "sideBar.background" = colors.background;
    #       "sideBar.foreground" = colors.foreground;
    #       "sideBarSectionHeader.background" = colors.lineHighlight;
    #       "statusBar.background" = colors.lineHighlight;
    #       "statusBar.foreground" = colors.foreground;
    #       "tab.activeBackground" = colors.background;
    #       "tab.activeForeground" = colors.foreground;
    #       "tab.border" = colors.background;
    #       "tab.inactiveBackground" = colors.lineHighlight;
    #       "tab.inactiveForeground" = colors.comment;
    #       "terminal.ansiBlack" = colors.black;
    #       "terminal.ansiBlue" = colors.blue;
    #       "terminal.ansiBrightBlack" = colors.brightBlack;
    #       "terminal.ansiBrightBlue" = colors.brightBlue;
    #       "terminal.ansiBrightCyan" = colors.brightCyan;
    #       "terminal.ansiBrightGreen" = colors.brightGreen;
    #       "terminal.ansiBrightMagenta" = colors.brightMagenta;
    #       "terminal.ansiBrightRed" = colors.brightRed;
    #       "terminal.ansiBrightWhite" = colors.brightWhite;
    #       "terminal.ansiBrightYellow" = colors.brightYellow;
    #       "terminal.ansiCyan" = colors.cyan;
    #       "terminal.ansiGreen" = colors.green;
    #       "terminal.ansiMagenta" = colors.magenta;
    #       "terminal.ansiRed" = colors.red;
    #       "terminal.ansiWhite" = colors.white;
    #       "terminal.ansiYellow" = colors.yellow;
    #       "titleBar.activeBackground" = colors.background;
    #       "titleBar.activeForeground" = colors.foreground;
    #     };
    #     tokenColors = [
    #       {
    #         scope = [
    #           "comment"
    #           "punctuation.definition.comment"
    #         ];
    #         settings = {
    #           foreground = colors.comment;
    #           fontStyle = "italic";
    #         };
    #       }
    #       {
    #         scope = [
    #           "entity.name"
    #           "variable"
    #           "variable.other.member"
    #           "support.variable"
    #           "meta.attribute"
    #           "entity.other.attribute-name"
    #           "support.type.property-name"
    #           "meta.object-literal.key"
    #         ];
    #         settings.foreground = colors.nameColor;
    #       }
    #       {
    #         scope = [
    #           "entity.name.function"
    #           "support.function"
    #           "meta.function-call"
    #           "variable.function"
    #         ];
    #         settings.foreground = colors.function;
    #       }
    #       {
    #         scope = [
    #           "string"
    #           "constant.numeric"
    #           "constant.language"
    #           "constant.character"
    #           "variable.parameter"
    #         ];
    #         settings.foreground = colors.value;
    #       }
    #       {
    #         scope = [
    #           "keyword"
    #           "storage"
    #           "storage.type"
    #           "keyword.operator"
    #         ];
    #         settings.foreground = colors.keyword;
    #       }
    #       {
    #         scope = [
    #           "entity.name.type"
    #           "entity.name.class"
    #           "support.type"
    #           "support.class"
    #         ];
    #         settings.foreground = colors.type;
    #       }
    #       {
    #         scope = [
    #           "invalid"
    #           "markup.deleted"
    #           "message.error"
    #         ];
    #         settings.foreground = colors.error;
    #       }
    #     ];
    #   };
    #   reactorThemeExtension = pkgs.vscode-utils.buildVscodeExtension {
    #     pname = "reactor-theme";
    #     version = "1.0.0";
    #     vscodeExtPublisher = "halcyonomega";
    #     vscodeExtName = "reactor-theme";
    #     vscodeExtUniqueId = "halcyonomega.reactor-theme";
    #     sourceRoot = ".";
    #     src = pkgs.runCommand "reactor-vscode-theme-src" { } ''
    #       mkdir -p "$out/themes"
    #       cat > "$out/package.json" <<'JSON'
    #       {
    #         "name": "reactor-theme",
    #         "displayName": "Reactor Theme",
    #         "description": "Reactor theme generated from the NexOS Base16 palette.",
    #         "version": "1.0.0",
    #         "publisher": "halcyonomega",
    #         "engines": {
    #           "vscode": "^1.80.0"
    #         },
    #         "categories": [
    #           "Themes"
    #         ],
    #         "contributes": {
    #           "themes": [
    #             {
    #               "label": "Reactor",
    #               "uiTheme": "vs-dark",
    #               "path": "./themes/reactor-color-theme.json"
    #             }
    #           ]
    #         }
    #       }
    #       JSON
    #       cat > "$out/themes/reactor-color-theme.json" <<'JSON'
    #       ${reactorThemeJson}
    #       JSON
    #     '';
    #   };
    # in
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

              ## Color Scheme
              # enkia.tokyo-night
              # PKief.material-icon-theme
              # reactorThemeExtension
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
