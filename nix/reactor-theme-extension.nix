{ pkgs, terminalTheme }:
let
  colors = terminalTheme.colors;
  reactorThemeJson = builtins.toJSON {
    name = "Reactor";
    type = "dark";
    semanticHighlighting = true;
    colors = {
      "activityBar.background" = colors.background;
      "activityBar.foreground" = colors.foreground;
      "activityBarBadge.background" = colors.cyan;
      "activityBarBadge.foreground" = colors.cursor-text;
      "badge.background" = colors.selection-background;
      "badge.foreground" = colors.selection-foreground;
      "button.background" = colors.blue;
      "button.foreground" = colors.selection-foreground;
      "button.hoverBackground" = colors.cyan;
      "editor.background" = colors.background;
      "editor.foreground" = colors.foreground;
      "editor.lineHighlightBackground" = colors.lineHighlight;
      "editor.selectionBackground" = colors.selection-background;
      "editor.selectionForeground" = colors.selection-foreground;
      "editor.inactiveSelectionBackground" = colors.selection-background;
      "editorCursor.foreground" = colors.cursor-color;
      "editorGroupHeader.tabsBackground" = colors.background;
      "editorLineNumber.activeForeground" = colors.highlightForeground;
      "editorLineNumber.foreground" = colors.foregroundMuted;
      "editorWhitespace.foreground" = colors.foregroundMuted;
      "editorWidget.background" = colors.lineHighlight;
      "editorWidget.border" = colors.selection-background;
      "focusBorder" = colors.cyan;
      "input.background" = colors.lineHighlight;
      "input.foreground" = colors.foreground;
      "input.border" = colors.selection-background;
      "list.activeSelectionBackground" = colors.selection-background;
      "list.activeSelectionForeground" = colors.selection-foreground;
      "list.focusBackground" = colors.selection-background;
      "list.hoverBackground" = colors.lineHighlight;
      "list.inactiveSelectionBackground" = colors.lineHighlight;
      "panel.background" = colors.background;
      "panel.border" = colors.selection-background;
      "panelTitle.activeForeground" = colors.highlightForeground;
      "peekViewEditor.background" = colors.background;
      "peekViewResult.background" = colors.lineHighlight;
      "scrollbarSlider.activeBackground" = colors.selection-background;
      "scrollbarSlider.background" = colors.selection-background;
      "scrollbarSlider.hoverBackground" = colors.foregroundMuted;
      "sideBar.background" = colors.background;
      "sideBar.foreground" = colors.foreground;
      "sideBarTitle.foreground" = colors.highlightForeground;
      "sideBarSectionHeader.background" = colors.lineHighlight;
      "sideBarSectionHeader.foreground" = colors.highlightForeground;
      "statusBar.background" = colors.lineHighlight;
      "statusBar.foreground" = colors.foreground;
      "statusBar.noFolderBackground" = colors.lineHighlight;
      "tab.activeBackground" = colors.background;
      "tab.activeForeground" = colors.highlightForeground;
      "tab.border" = colors.background;
      "tab.inactiveBackground" = colors.lineHighlight;
      "tab.inactiveForeground" = colors.foregroundMuted;
      "terminal.ansiBlack" = colors.black;
      "terminal.ansiBlue" = colors.blue;
      "terminal.ansiBrightBlack" = colors.brightBlack;
      "terminal.ansiBrightBlue" = colors.brightBlue;
      "terminal.ansiBrightCyan" = colors.brightCyan;
      "terminal.ansiBrightGreen" = colors.brightGreen;
      "terminal.ansiBrightMagenta" = colors.brightMagenta;
      "terminal.ansiBrightRed" = colors.brightRed;
      "terminal.ansiBrightWhite" = colors.brightWhite;
      "terminal.ansiBrightYellow" = colors.brightYellow;
      "terminal.ansiCyan" = colors.cyan;
      "terminal.ansiGreen" = colors.green;
      "terminal.ansiMagenta" = colors.magenta;
      "terminal.ansiRed" = colors.red;
      "terminal.ansiWhite" = colors.white;
      "terminal.ansiYellow" = colors.yellow;
      "terminal.foreground" = colors.foreground;
      "titleBar.activeBackground" = colors.background;
      "titleBar.activeForeground" = colors.foreground;
      "tree.indentGuidesStroke" = colors.foregroundMuted;
    };
    semanticTokenColors = {
      namespace = colors.type;
      type = colors.type;
      class = colors.type;
      struct = colors.type;
      interface = colors.type;
      enum = colors.type;
      typeParameter = colors.magenta;
      parameter = colors.value;
      variable = colors.nameColor;
      property = colors.nameColor;
      enumMember = colors.value;
      decorator = colors.orange;
      function = colors.function;
      method = colors.function;
      member = colors.function;
      event = colors.yellow;
      modifier = colors.keyword;
    };
    tokenColors = [
      {
        scope = [
          "comment"
          "punctuation.definition.comment"
        ];
        settings = {
          foreground = colors.comment;
          fontStyle = "italic";
        };
      }
      {
        scope = [
          "punctuation"
          "punctuation.definition.dollar"
          "punctuation.terminator"
        ];
        settings.foreground = colors.foregroundMuted;
      }
      {
        scope = [
          "punctuation.separator"
          "meta.brace"
          "meta.array"
          "meta.block"
        ];
        settings.foreground = colors.foreground;
      }
      {
        scope = [
          "keyword"
          "storage"
          "storage.type"
        ];
        settings.foreground = colors.keyword;
      }
      {
        scope = [
          "keyword.operator"
          "keyword.operator.logical"
          "keyword.operator.comparison"
        ];
        settings.foreground = colors.cyan;
      }
      {
        scope = [
          "entity.name"
          "support.variable"
          "meta.attribute"
          "entity.other.attribute-name"
          "support.type.property-name"
        ];
        settings.foreground = colors.nameColor;
      }
      {
        scope = [
          "variable"
          "variable.other.member"
          "meta.object-literal.key"
        ];
        settings.foreground = colors.nameColor;
      }
      {
        scope = [
          "entity.name.function"
          "support.function"
          "meta.function-call"
          "variable.function"
        ];
        settings.foreground = colors.function;
      }
      {
        scope = [
          "string"
          "constant.numeric"
          "constant.language"
          "constant.character"
          "string.regexp"
        ];
        settings.foreground = colors.value;
      }
      {
        scope = [
          "variable.parameter"
        ];
        settings = {
          foreground = colors.value;
          fontStyle = "italic";
        };
      }
      {
        scope = [
          "entity.name.type"
          "entity.name.class"
          "support.type"
          "support.class"
        ];
        settings.foreground = colors.type;
      }
      {
        scope = [
          "invalid"
          "markup.deleted"
          "message.error"
        ];
        settings.foreground = colors.error;
      }
    ];
  };
in
pkgs.vscode-utils.buildVscodeExtension {
  pname = "reactor-theme";
  version = "1.0.0";
  vscodeExtPublisher = "halcyonomega";
  vscodeExtName = "reactor-theme";
  vscodeExtUniqueId = "halcyonomega.reactor-theme";
  sourceRoot = ".";
  src = pkgs.runCommand "reactor-vscode-theme-src" { } ''
    mkdir -p "$out/themes"
    cat > "$out/package.json" <<'JSON'
    {
      "name": "reactor-theme",
      "displayName": "Reactor Theme",
      "description": "Reactor theme generated from the NexOS Base16 palette.",
      "version": "1.0.0",
      "publisher": "halcyonomega",
      "engines": {
        "vscode": "^1.80.0"
      },
      "categories": [
        "Themes"
      ],
      "contributes": {
        "themes": [
          {
            "label": "Reactor",
            "uiTheme": "vs-dark",
            "path": "./themes/reactor-color-theme.json"
          }
        ]
      }
    }
    JSON
    cat > "$out/themes/reactor-color-theme.json" <<'JSON'
    ${reactorThemeJson}
    JSON
  '';
}
