{ inputs, ... }:
{
  flake.nixosModules.user =
    { username, ... }:
    {
      users.users.${username} = {
        isNormalUser = true;
        description = "${username}";
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "podman"
          "mlocate"
        ];
        initialPassword = "password";
      };

      nix.settings.allowed-users = [ "${username}" ];
    };
}
