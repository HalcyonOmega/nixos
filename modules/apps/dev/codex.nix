{ inputs, ... }:
{
  flake.nixosModules.codex =
    {
      inputs,
      pkgs,
      system,
      username,
      ...
    }:
    let
      # Codex CLI (0.144.x, GPT-5.6) from OpenAI's official release binaries.
      # Bump via `nix flake update codex-cli-nix`.
      codexCli = inputs.codex-cli-nix.packages.${system}.default;
      cliproxyapi = inputs.cliproxyapi.packages.${system}.cliproxyapi;
      # Remote mobile control only — no Computer Use / AT-SPI.
      codexDesktop =
        inputs.codex-desktop-linux.packages.${system}.codex-desktop-remote-mobile-control;
      responsiveCodexDesktop = pkgs.symlinkJoin {
        name = "${codexDesktop.name}-responsive";
        paths = [ codexDesktop ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          rm -f "$out/bin/codex-desktop"
          makeWrapper "${codexDesktop}/bin/codex-desktop" "$out/bin/codex-desktop" \
            --set-default CODEX_CLI_PATH "${codexCli}/bin/codex"

          desktopFile="$out/share/applications/codex-desktop.desktop"
          target="$(readlink -f "$desktopFile")"
          rm -f "$desktopFile"
          substitute "$target" "$desktopFile" \
            --replace-fail "${codexDesktop}/bin/codex-desktop" "$out/bin/codex-desktop"
        '';
      };
    in
    {
      home-manager.users.${username} = {
        imports = [ inputs.codex-desktop-linux.homeManagerModules.default ];

        home.packages = [
          codexCli
          cliproxyapi
        ];

        # User-local desktop entries override the system profile immediately;
        # the integrated Home Manager profile updates on the next OS switch.
        xdg.dataFile."applications/codex-desktop.desktop".source =
          "${responsiveCodexDesktop}/share/applications/codex-desktop.desktop";

        # Desktop app (upstream renamed Codex -> ChatGPT; this flake repackages
        # the new ChatGPT.dmg). Bump via `nix flake update codex-desktop-linux`.
        programs.codexDesktopLinux = {
          enable = true;
          package = responsiveCodexDesktop;
          # Bake CODEX_CLI_PATH into the launcher so the app finds the CLI even
          # when started from the application launcher without profile PATH.
          cliPackage = codexCli;
        };
      };
    };
}
