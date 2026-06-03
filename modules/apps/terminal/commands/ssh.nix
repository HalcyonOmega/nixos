{ inputs, ... }:
{
  flake.nixosModules.ssh =
    {
      username,
      ...
    }:
    {
      services.openssh.enable = true;

      home-manager.users.${username} = {
        programs.ssh = {
          enable = true;

          # Disable default Host * configuration
          enableDefaultConfig = false;

          # Common SSH settings for all hosts (*)
          settings = {
            "*" = {
              AddKeysToAgent = "1h";
              ControlMaster = "auto";
              ControlPath = "~/.ssh/control-%r@%h:%p";
              ControlPersist = "10m";
            };

            "github.com" = {
              HostName = "ssh.github.com";
              User = "git";
              Port = 443;
              IdentityFile = "~/.ssh/id_github";
              IdentitiesOnly = true;
            };
          };
        };

        services.ssh-agent.enable = true;
      };
    };
}
