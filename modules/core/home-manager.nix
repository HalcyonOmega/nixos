{ inputs, ... }:
{
  flake.nixosModules.home-manager =
    {
      username,
      ...
    }:
    {
      home-manager.users.${username} = {
        programs.home-manager.enable = true;
      };
    };
}
