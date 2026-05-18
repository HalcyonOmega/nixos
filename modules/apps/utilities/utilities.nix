{ inputs, self, ... }:
{
  flake.nixosModules.utilities =
    { ... }:
    {
      imports = [
        self.nixosModules.bitwarden
        self.nixosModules.fonts
        self.nixosModules.gparted
        self.nixosModules.gtk
        self.nixosModules.home-manager
        self.nixosModules.podman
        self.nixosModules.solaar
        self.nixosModules.vicinae
        self.nixosModules.xdg-mimes
        # self.nixosModules.xorg
      ];
    };
}
