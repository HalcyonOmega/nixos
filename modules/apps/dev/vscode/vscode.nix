{ inputs, self, ... }:
{
  flake.nixosModules.vscode =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        programs.vscodium = {
          enable = true;
          package = pkgs.vscodium;
        };
      };
      imports = [
        self.nixosModules.vscode-extensions
        self.nixosModules.vscode-keybinds
        self.nixosModules.vscode-settings
      ];
    };
}
