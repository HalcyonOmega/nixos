{ inputs, ... }:
{
  flake.nixosModules.zen =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        imports = [ inputs.zen-browser.homeModules.beta ];

        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = true;

          policies = {
            SecurityDevices = {
              "OpenSC PKCS#11" = "${pkgs.opensc}/lib/pkcs11/opensc-pkcs11.so";
            };

            ExtensionSettings = {
              "uBlock0@raymondhill.net" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                installation_mode = "force_installed";
              };

              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                installation_mode = "force_installed";
              };
            };
          };

          profiles.default = { };
        };

        stylix.targets.zen-browser.profileNames = [ "default" ];
      };
    };
}
