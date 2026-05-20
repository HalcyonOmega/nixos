{ inputs, self, ... }:
{
  flake.nixosModules.hardware =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        self.nixosModules.bluetooth
        self.nixosModules.graphics
        self.nixosModules.keyboard
        self.nixosModules.mouse
      ];

      environment.systemPackages = [
        pkgs.libva-utils
        pkgs.vdpauinfo
        pkgs.vulkan-tools
      ];

      services.udev.extraRules = builtins.concatStringsSep "\n" [
        # rule for via firmware flashing
        ''
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
        ''

        # rules for oryx web flashing and live training
        ''
          KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
          KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
        ''
        # rules for lossless adapter
        ''
          SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
          SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="102b", MODE="0666"
        ''
      ];
    };
}
