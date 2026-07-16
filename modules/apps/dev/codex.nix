{ inputs, ... }:
{
  flake.nixosModules.codex =
    {
      inputs,
      system,
      username,
      ...
    }:
    let
      # Codex CLI (0.144.x, GPT-5.6) from OpenAI's official release binaries.
      # Bump via `nix flake update codex-cli-nix`.
      codexCli = inputs.codex-cli-nix.packages.${system}.default;
    in
    {
      home-manager.users.${username} = {
        imports = [ inputs.codex-desktop-linux.homeManagerModules.default ];

        home.packages = [ codexCli ];

        # Desktop app (upstream renamed Codex -> ChatGPT; this flake repackages
        # the new ChatGPT.dmg). Bump via `nix flake update codex-desktop-linux`.
        programs.codexDesktopLinux = {
          enable = true;
          computerUseUi.enable = true;
          remoteMobileControl.enable = true;
          # Bake CODEX_CLI_PATH into the launcher so the app finds the CLI even
          # when started from the application launcher without profile PATH.
          cliPackage = codexCli;
        };
      };
    };
}
