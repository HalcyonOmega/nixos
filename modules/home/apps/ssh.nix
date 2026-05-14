{ config, pkgs, username, ... }:
{
  home-manager.users.${username} = {
    programs.ssh = {
      enable = true;

      # Disable default Host * configuration
      enableDefaultConfig = false;

      # Common SSH settings for all hosts (*)
      matchBlocks = {
        "*" = {
          addKeysToAgent = "1h";
          controlMaster = "auto";
          controlPath = "~/.ssh/control-%r@%h:%p";
          controlPersist = "10m";
        };

        github = {
          host = "github.com";
          hostname = "ssh.github.com";
          user = "Zolkyed";
          port = 443;
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };
      };
    };

    services.ssh-agent.enable = true;
  };
}