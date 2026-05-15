{ username, ... }:
{
  home-manager.users.${username} = {
    programs.vscodium.profiles.default = {
      keybindings = [
        {
          key = "ctrl+s";
          command = "workbench.action.files.saveFiles";
        }
      ];
    };
  };
}
