{ inputs, self, ... }:
{
  flake.nixosModules.gaming =
    { ... }:
    {
      imports = [
        self.nixosModules.gamemode
        self.nixosModules.protontricks
        self.nixosModules.protonup-qt
        self.nixosModules.steam
        self.nixosModules.wine
        self.nixosModules.winetricks
      ];
    };
}
