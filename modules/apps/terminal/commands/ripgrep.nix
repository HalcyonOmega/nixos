{ inputs, ... }:
{
  flake.nixosModules.ripgrep =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.ripgrep
        ];

        programs.ripgrep = {
          enable = true;

          arguments = [
            "--max-columns=2000"
            "--smart-case"
          ];
        };
      };
    };
}
