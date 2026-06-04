{ inputs, self, ... }:
{
  flake.nixosModules.utilities =
    { ... }:
    {
      imports = [
        self.nixosModules.bitwarden
        self.nixosModules.docker
        self.nixosModules.flameshot
        self.nixosModules.gparted
        self.nixosModules.localsend
        self.nixosModules.qalculate
        # self.nixosModules.remmina
        self.nixosModules.solaar
        self.nixosModules.streamcontroller
        self.nixosModules.tailscale
        self.nixosModules.vicinae
        self.nixosModules.winboat
      ];
    };
}
