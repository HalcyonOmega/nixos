{
  pkgs,
  username,
  ...
}:
{
  # programs.fish.enable = true;

  # environment.shellAliases = {
  #   l = "ls -lh --color=auto";
  #   c = "clear";
  #   disk = "lsblk -f";
  #   ff = "fastfetch";
  #   nit = "nitch";
  # };

  # environment.sessionVariables = {
  #   NIXOS_OZONE_WL = "1";
  # };

  # users.users.${username} = {
  #   isNormalUser = true;
  #   description = "${username}";
  #   extraGroups = [
  #     "networkmanager"
  #     "wheel"
  #     "libvirtd"
  #     "mlocate"
  #   ];
  #   shell = pkgs.fish;
  #   initialPassword = "password";
  # };

  # nix.settings.allowed-users = [ "${username}" ];
}
