{ inputs, ... }:
{
  flake.nixosModules.btop =
    {
      pkgs,
      username,
      ...
    }:
    {
      home-manager.users.${username} = {
        programs.btop = {
          enable = true;
          package = pkgs.btop;
        };
      };
    };
}
