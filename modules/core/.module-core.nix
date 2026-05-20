{ inputs, self, ... }:
{
  flake.nixosModules.core =
    { ... }:
    {
      imports = [
        self.nixosModules.hardware
        self.nixosModules.style

        self.nixosModules.audio
        self.nixosModules.boot
        self.nixosModules.network
        self.nixosModules.localization
        self.nixosModules.program
        self.nixosModules.sched-ext
        self.nixosModules.security
        self.nixosModules.system
        self.nixosModules.user
        self.nixosModules.virtualization
        self.nixosModules.wayland
        self.nixosModules.xdg-mimes
        # self.nixosModules.xorg
        self.nixosModules.zram
      ];
    };
}
