{
  username,
  ...
}:
{
  home-manager.users.${username} = {
    programs.home-manager.enable = true;
  };
}