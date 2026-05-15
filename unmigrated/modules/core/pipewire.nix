{ pkgs, ... }:
{
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # @Nate TODO: Consider adding
      # lowLatency.enable = true;
    };
  };

  hardware.alsa.enablePersistence = true;
  environment.systemPackages = [ pkgs.pulseaudioFull ];
}
