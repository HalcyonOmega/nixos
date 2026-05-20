{ inputs, ... }:
{
  flake.nixosModules.user =
    { username, ... }:
    {
      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "mlocate"
        ];
      };
    };
}
