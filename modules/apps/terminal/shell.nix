{ inputs, ... }:
{
  flake.nixosModules.shell =
    { pkgs, username, ... }:
    {
      users.users.${username} = {
        shell = pkgs.fish;
      };
    };
}
