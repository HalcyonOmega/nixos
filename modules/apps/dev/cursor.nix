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
              # Podman exposes the Docker-compatible CLI (dockerCompat + dockerSocket).
              "dev.containers.dockerPath" = "/run/current-system/sw/bin/docker";
              "dev.containers.dockerComposePath" = lib.getExe pkgs.docker-compose;
            };
          };
        };
      };
    };
}
