{ inputs, ... }:
{
  flake.nixosModules.cursor =
    { pkgs, username, lib, ... }:
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
              # Podman exposes the Docker-compatible CLI (dockerCompat + dockerSocket).
              "dev.containers.dockerPath" = "/run/current-system/sw/bin/docker";
              "dev.containers.dockerComposePath" = lib.getExe pkgs.docker-compose;
              "remote.containers.dockerPath" = "/run/current-system/sw/bin/docker";
              "remote.containers.dockerComposePath" = lib.getExe pkgs.docker-compose;
            };
          };
        };
      };
    };
}
