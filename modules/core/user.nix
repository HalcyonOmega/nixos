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
          "mlocate"
        ];
        initialPassword = "password";
      };
    };
}
