{ inputs, ... }:
{
  flake.nixosModules.vicinae =
    {
      pkgs,
      username,
      inputs,
      ...
    }:

    {

      home-manager.users.${username} = {
        home.packages = [ inputs.vicinae ];

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
