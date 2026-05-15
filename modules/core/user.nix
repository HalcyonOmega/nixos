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

  nix.settings.allowed-users = [ "${username}" ];
}
