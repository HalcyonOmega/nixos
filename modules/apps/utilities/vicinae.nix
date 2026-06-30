{ inputs, ... }:
{
  flake.nixosModules.vicinae =
    {
      pkgs,
      username,
      inputs,
      ...
    }:

    let
      toggleKeepAwake = pkgs.writeShellScript "vicinae-toggle-keep-awake" ''
        # @vicinae.schemaVersion 1
        # @vicinae.title Toggle Keep Awake
        # @vicinae.mode compact
        # @vicinae.icon ☀️
        # @vicinae.keywords ["sleep", "awake", "presentation", "inhibit", "power", "lock"]
        # @vicinae.description Block sleep, screen lock, and dimming until toggled off again

        set -eu

        if ${pkgs.systemd}/bin/systemctl --user is-active --quiet keep-awake.service; then
          ${pkgs.systemd}/bin/systemctl --user stop keep-awake.service
          echo "Keep awake disabled"
        else
          ${pkgs.systemd}/bin/systemctl --user start keep-awake.service
          echo "Keep awake enabled"
        fi
      '';

      startKeepAwake = pkgs.writeShellScript "vicinae-start-keep-awake" ''
        # @vicinae.schemaVersion 1
        # @vicinae.title Start Keep Awake
        # @vicinae.mode compact
        # @vicinae.icon ☀️
        # @vicinae.keywords ["sleep", "awake", "presentation", "inhibit", "power", "lock"]
        # @vicinae.description Block sleep, screen lock, and dimming

        set -eu

        ${pkgs.systemd}/bin/systemctl --user start keep-awake.service
        echo "Keep awake enabled"
      '';

      stopKeepAwake = pkgs.writeShellScript "vicinae-stop-keep-awake" ''
        # @vicinae.schemaVersion 1
        # @vicinae.title Stop Keep Awake
        # @vicinae.mode compact
        # @vicinae.icon 🌙
        # @vicinae.keywords ["sleep", "awake", "presentation", "inhibit", "power", "lock"]
        # @vicinae.description Re-enable normal sleep, lock, and dimming

        set -eu

        ${pkgs.systemd}/bin/systemctl --user stop keep-awake.service
        echo "Keep awake disabled"
      '';
    in
    {

      home-manager.users.${username} = {
        home.packages = [ inputs.vicinae ];

        xdg.dataFile = {
          "vicinae/scripts/toggle-keep-awake" = {
            source = toggleKeepAwake;
            executable = true;
          };
          "vicinae/scripts/start-keep-awake" = {
            source = startKeepAwake;
            executable = true;
          };
          "vicinae/scripts/stop-keep-awake" = {
            source = stopKeepAwake;
            executable = true;
          };
        };

        services.vicinae = {
          enable = true;
          systemd = {
            enable = true;
            autoStart = true; # default: false
            environment = {
              USE_LAYER_SHELL = 1;
            };
          };
          settings = {
            close_on_focus_loss = true;
            consider_preedit = true;
            pop_to_root_on_close = true;
            favicon_service = "twenty";
            search_files_in_root = true;
            font = {
              normal = {
                size = 12;
                family = "Atkinson Hyperlegible Next";
              };
            };
            launcher_window = {
              # opacity = 0.98;
            };
            providers = {
              applications = {
                entrypoints = {
                  cursor-code.alias = "cur";
                  codium.alias = "cod";
                  brave-browser.alias = "br";
                  bitwarden.alias = "bit";
                  systemsettings.alias = "set";
                };
              };
            };
          };
          extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
            bluetooth
            nix
            power-profile
            # flathub - find name
            # systemd - find name
            chromium-bookmarks
            # Extension names are just the folder names
          ];
        };
      };
    };
}
