{ inputs, ... }:
{
  flake.nixosModules.style =
    {
      lib,
      ...
    }:

    let
      withHash = color: "#${color}";

      parseBase16Yaml =
        path:
        let
          parseLine =
            line:
            let
              trimmed = lib.trim line;
              quotedMatch = builtins.match ''([A-Za-z0-9]+): "([^"]*)".*'' trimmed;
              plainMatch = builtins.match "([A-Za-z0-9]+): ([^ #]+).*" trimmed;
            in
            if quotedMatch != null then
              {
                name = builtins.elemAt quotedMatch 0;
                value = builtins.elemAt quotedMatch 1;
              }
            else if plainMatch != null then
              {
                name = builtins.elemAt plainMatch 0;
                value = builtins.elemAt plainMatch 1;
              }
            else
              null;
        in
        builtins.listToAttrs (
          builtins.filter (entry: entry != null) (
            map parseLine (lib.splitString "\n" (builtins.readFile path))
          )
        );

      mkGhosttyPalette = colors: [
        "0=${colors.black}"
        "1=${colors.red}"
        "2=${colors.green}"
        "3=${colors.yellow}"
        "4=${colors.blue}"
        "5=${colors.magenta}"
        "6=${colors.cyan}"
        "7=${colors.white}"
        "8=${colors.brightBlack}"
        "9=${colors.brightRed}"
        "10=${colors.brightGreen}"
        "11=${colors.brightYellow}"
        "12=${colors.brightBlue}"
        "13=${colors.brightMagenta}"
        "14=${colors.brightCyan}"
        "15=${colors.brightWhite}"
      ];

      mkGhosttyTheme = colors: {
        inherit (colors)
          background
          foreground
          selection-background
          selection-foreground
          cursor-color
          cursor-text
          ;
        palette = mkGhosttyPalette colors;
      };

      mkBatTheme = colors: ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
          "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>name</key>
          <string>${colors.name}</string>
          <key>settings</key>
          <array>
            <dict>
              <key>settings</key>
              <dict>
                <key>background</key>
                <string>${colors.background}</string>
                <key>foreground</key>
                <string>${colors.foreground}</string>
                <key>caret</key>
                <string>${colors.cursor-color}</string>
                <key>selection</key>
                <string>${colors.selection-background}</string>
                <key>lineHighlight</key>
                <string>${colors.lineHighlight}</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Comments</string>
              <key>scope</key>
              <string>comment, punctuation.definition.comment</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>${colors.comment}</string>
                <key>fontStyle</key>
                <string>italic</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Names and attributes</string>
              <key>scope</key>
              <string>entity.name, variable, variable.other.member, support.variable, meta.attribute, entity.other.attribute-name, support.type.property-name, meta.object-literal.key</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>${colors.nameColor}</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Functions</string>
              <key>scope</key>
              <string>entity.name.function, support.function, meta.function-call, variable.function</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>${colors.function}</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Values</string>
              <key>scope</key>
              <string>string, constant.numeric, constant.language, constant.character, variable.parameter, meta.tag string</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>${colors.value}</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Keywords and operators</string>
              <key>scope</key>
              <string>keyword, storage, storage.type, keyword.operator</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>${colors.keyword}</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Types and classes</string>
              <key>scope</key>
              <string>entity.name.type, entity.name.class, support.type, support.class</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>${colors.type}</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Errors and invalid</string>
              <key>scope</key>
              <string>invalid, markup.deleted, message.error</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>${colors.error}</string>
              </dict>
            </dict>
          </array>
          <key>uuid</key>
          <string>${colors.uuid}</string>
        </dict>
        </plist>
      '';

      mkBtopTheme =
        colors:
        lib.concatStringsSep "\n" [
          ''theme[main_bg]="${colors.background}"''
          ''theme[main_fg]="${colors.foreground}"''
          ''theme[title]="${colors.cyan}"''
          ''theme[hi_fg]="${colors.nameColor}"''
          ''theme[selected_bg]="${colors.selection-background}"''
          ''theme[selected_fg]="${colors.selection-foreground}"''
          ''theme[inactive_fg]="${colors.comment}"''
          ''theme[meter_bg]="${colors.lineHighlight}"''
          ''theme[graph_text]="${colors.foreground}"''
          ''theme[proc_misc]="${colors.blue}"''
          ''theme[cpu_box]="${colors.blue}"''
          ''theme[mem_box]="${colors.value}"''
          ''theme[net_box]="${colors.nameColor}"''
          ''theme[proc_box]="${colors.comment}"''
          ''theme[div_line]="${colors.comment}"''
          ''theme[temp_start]="${colors.nameColor}"''
          ''theme[temp_mid]="${colors.value}"''
          ''theme[temp_end]="${colors.error}"''
          ''theme[cpu_start]="${colors.nameColor}"''
          ''theme[cpu_mid]="${colors.blue}"''
          ''theme[cpu_end]="${colors.value}"''
          ''theme[free_start]="${colors.comment}"''
          ''theme[free_mid]="${colors.value}"''
          ''theme[free_end]="${colors.nameColor}"''
          ''theme[cached_start]="${colors.comment}"''
          ''theme[cached_mid]="${colors.blue}"''
          ''theme[cached_end]="${colors.nameColor}"''
          ''theme[available_start]="${colors.comment}"''
          ''theme[available_mid]="${colors.blue}"''
          ''theme[available_end]="${colors.nameColor}"''
          ''theme[used_start]="${colors.nameColor}"''
          ''theme[used_mid]="${colors.value}"''
          ''theme[used_end]="${colors.error}"''
          ''theme[download_start]="${colors.nameColor}"''
          ''theme[download_mid]="${colors.blue}"''
          ''theme[download_end]="${colors.value}"''
          ''theme[upload_start]="${colors.blue}"''
          ''theme[upload_mid]="${colors.value}"''
          ''theme[upload_end]="${colors.error}"''
          ""
        ];

      mkColorsFromBase16 =
        scheme:
        let
          base00 = withHash scheme.base00;
          base01 = withHash scheme.base01;
          base02 = withHash scheme.base02;
          base03 = withHash scheme.base03;
          base05 = withHash scheme.base05;
          base07 = withHash scheme.base07;
          base08 = withHash scheme.base08;
          base0A = withHash scheme.base0A;
          base0B = withHash scheme.base0B;
          base0C = withHash scheme.base0C;
          base0D = withHash scheme.base0D;
          base0E = withHash scheme.base0E;
          base0F = withHash scheme.base0F;
        in
        {
          inherit scheme;

          name = scheme.scheme;
          background = base00;
          foreground = base05;
          selection-background = base02;
          selection-foreground = base07;
          cursor-color = base0C;
          cursor-text = base00;
          lineHighlight = base01;
          comment = base03;
          nameColor = base0C;
          function = base0D;
          value = base0A;
          keyword = base08;
          type = base0E;
          error = base08;
          uuid = "25a70143-aad6-4ef5-89f7-reactor";
          black = base00;
          red = base08;
          green = base0B;
          yellow = base0A;
          blue = base0D;
          magenta = base0E;
          cyan = base0C;
          white = base05;
          brightBlack = base03;
          brightRed = base08;
          brightGreen = base0B;
          brightYellow = base0A;
          brightBlue = base0D;
          brightMagenta = base0E;
          brightCyan = base0C;
          brightWhite = base07;
          brown = base0F;
        };

      mkTheme = colors: {
        inherit colors;
        ghostty = mkGhosttyTheme colors;
        bat = mkBatTheme colors;
        btop = mkBtopTheme colors;
      };

      reactorScheme = parseBase16Yaml ../../assets/themes/base16/reactor.yaml;
      terminalTheme = mkTheme (mkColorsFromBase16 reactorScheme);
    in
    {
      _module.args.terminalTheme = terminalTheme;

      stylix = {
        enable = true;
        image = ./../../assets/wallpapers/vortex.jpg;
        polarity = "dark";

        base16Scheme = ./../../assets/themes/reactor.yaml;
        #   # base16Scheme = {
        #   #   system = "base16";
        #   #   name = "selenized-black";
        #   #   author = "Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali";
        # variant = "dark";

        # palette = {
        #   base00 = "0b0f14";
        #   base01 = "141a21";
        #   base02 = "222b35";
        #   base03 = "53616f";
        #   base04 = "8d9aa7";
        #   base05 = "c8d0d8";
        #   base06 = "e4e9ee";
        #   base07 = "f7f9fb";
        #   base08 = "ff4f58";
        #   base09 = "ff9f43";
        #   base0A = "f6c85f";
        #   base0B = "7bd88f";
        #   base0C = "3dd6d0";
        #   base0D = "46b4ff";
        #   base0E = "9d7cff";
        #   base0F = "d0765f";
        # };
        #   # };

        #   opacity = {
        #     terminal = opacity;
        #     popups = opacity;
        #   };

        #   cursor = {
        #     package = pkgs.phinger-cursors;
        #     name = "phinger-cursors";
        #     size = 24;
        #   };

        #   fonts = {
        #     # serif = {
        #     #   package = pkgs.aleo-fonts;
        #     #   name = "Aleo";
        #     # };
        #     serif = config.stylix.fonts.sansSerif;

        #     sansSerif = {
        #       package = pkgs.atkinson-hyperlegible-next;
        #       name = "Atkinson Hyperlegible Next";
        #     };

        #     monospace = {
        #       package = pkgs.atkinson-hyperlegible-mono;
        #       name = "Atkinson Hyperlegible Mono";
        #     };

        #     emoji = {
        #       package = pkgs.noto-fonts-color-emoji;
        #       name = "Noto Color Emoji";
        #     };

        #     sizes = {
        #       applications = fontSize;
        #       desktop = fontSize;
        #       popups = fontSize;
        #       terminal = fontSize;
        #     };
        #   };
      };
    };
}
