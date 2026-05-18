{ inputs, ... }:
{
  flake.nixosModules.cursor =
    {
      pkgs,
      username,
      ...
    }:
    {
      home-manager.users.${username} = {
        programs.cursor = {
          enable = true;
          package = pkgs.code-cursor;
          mutableExtensionsDir = false;
          profiles.default = {
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;
            extensions = [ pkgs.vscode-extensions.ms-vscode-remote.remote-containers ];
            userSettings = {
              "window.titleBarStyle" = "custom";
              "extensions.autoUpdate" = false;
              "editor.fontFamily" = "AtkynsonMono Nerd Font Mono";
              "terminal.integrated.fontFamily" = "AtkynsonMono Nerd Font Mono";
            };
          };
        };
      };
    };
}
