{ inputs, self, ... }:
{
  flake.nixosModules.core =
    { ... }:
    {
      imports = [
        self.nixosModules.appimage
        self.nixosModules.bluetooth
        self.nixosModules.bootloader
        self.nixosModules.mouse
        self.nixosModules.network
        self.nixosModules.hardware
        self.nixosModules.pipewire
        self.nixosModules.program
        self.nixosModules.sched-ext
        self.nixosModules.security
        self.nixosModules.style
        self.nixosModules.system
        self.nixosModules.user
        self.nixosModules.virtualization
        self.nixosModules.wayland
        self.nixosModules.zram
      ];
    };
}
