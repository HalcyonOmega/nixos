{
  config,
  pkgs,
  ...
}:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = [
    pkgs.libva-utils
    pkgs.vdpauinfo
    pkgs.vulkan-tools
  ];
}
