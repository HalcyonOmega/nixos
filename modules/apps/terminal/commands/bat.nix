{ inputs, ... }:
{
  flake.nixosModules.bat =
    {
      pkgs,
      username,
      terminalTheme,
      ...
    }:
    {
      home-manager.users.${username} = {
        programs.bat = {
          enable = true;
          config = {
            theme = terminalTheme.colors.name;
          };

          themes.${terminalTheme.colors.name} = {
            src = pkgs.writeTextDir "${terminalTheme.colors.name}.tmTheme" terminalTheme.bat;
            file = "${terminalTheme.colors.name}.tmTheme";
          };
        };
      };
    };
}
