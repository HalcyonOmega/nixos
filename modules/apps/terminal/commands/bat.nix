{ inputs, ... }:
{
  flake.nixosModules.bat =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.bat
        ];
      };
    };
}
