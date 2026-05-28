{ inputs, ... }:
{
  flake.nixosModules.docker =
    { pkgs, username, ... }:
    {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
      };

      users.users.${username}.extraGroups = [
        "docker"
        "kvm"
      ];

      environment.systemPackages = [
        pkgs.docker-compose
      ];

      home-manager.users.${username} = {
        home.packages = [
          pkgs.lazydocker
        ];
      };
    };
}
