{ inputs, self, ... }:
{
  flake.nixosModules.general =
    { ... }:
    {
      imports = [
        self.nixosModules.brave-origin
        self.nixosModules.brave
        self.nixosModules.discord
        self.nixosModules.logseq
        self.nixosModules.onlyoffice
        self.nixosModules.spicetify
        self.nixosModules.thunderbird
      ];
    };
}
