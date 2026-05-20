{ inputs, ... }:
{
  flake.nixosModules.bluetooth =
    { pkgs, ... }:
    {
      hardware = {
        bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings = {
            General = {
              Experimental = true;
            };
          };
        };

        logitech.wireless.enable = true;
        logitech.wireless.enableGraphical = true;
      };
    };
}
