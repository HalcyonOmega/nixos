{ username, ... }:
{
  home-manager.users.${username} = {
    programs.neovim = {
      enable = true;
      vimAlias = true;
    };
  };
}
