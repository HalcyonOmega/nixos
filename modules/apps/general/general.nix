{ inputs, self, ... }:
{
  flake.nixosModules.general =
    { ... }:
    {
      imports = [
        self.nixosModules.discord
        self.nixosModules.logseq
        self.nixosModules.onlyoffice
        self.nixosModules.spotify
        self.nixosModules.thunderbird
        self.nixosModules.vivaldi
      ];
    };
}
