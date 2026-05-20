{ inputs, ... }:
{
  flake.nixosModules.bat =
    {
      pkgs,
      username,
      ...
    }:
    {
      home-manager.users.${username} = {
        programs.bat = {
          enable = true;
        };
      };
    };
}
