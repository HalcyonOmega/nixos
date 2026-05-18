{ inputs, ... }:
{
  flake.nixosModules.librewolf =
    {
      pkgs,
      username,
      ...
    }:
    {
      home-manager.users.${username} = {
        programs.firefox = {
          enable = true;
          package = pkgs.librewolf;
          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            Preferences = {
              "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
              "cookiebanners.service.mode" = 2; # Block cookie banners
              "privacy.donottrackheader.enabled" = true;
              "privacy.fingerprintingProtection" = true;
              "privacy.resistFingerprinting" = true;
              "privacy.trackingprotection.emailtracking.enabled" = true;
              "privacy.trackingprotection.enabled" = true;
              "privacy.trackingprotection.fingerprinting.enabled" = true;
              "privacy.trackingprotection.socialtracking.enabled" = true;
              "ui.systemUsesDarkTheme" = 1;
              "browser.theme.content-theme" = 0;
              "browser.theme.toolbar-theme" = 0;
              "layout.css.prefers-color-scheme.content-override" = 0;
            };
            ExtensionSettings = {
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                installation_mode = "force_installed";
              };
              "jid1-ZAdIEUB7XOzOJw@jetpack" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
                installation_mode = "force_installed";
              };
              "uBlock0@raymondhill.net" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                installation_mode = "force_installed";
              };
              "addon@darkreader.org" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
                installation_mode = "force_installed";
              };
            };
          };
        };

      };

      # environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
    };
}
