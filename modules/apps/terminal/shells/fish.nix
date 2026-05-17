{ inputs, ... }:
{
  flake.nixosModules.fish =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.fish
        ];

        programs.fish = {
          enable = true;
          interactiveShellInit = ''
            set fish_greeting
          '';
        };
      };

      programs.fish = {
        enable = true;
        useBabelfish = true;
      };
    };
}
