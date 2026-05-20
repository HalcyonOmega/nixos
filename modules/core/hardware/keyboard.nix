{ inputs, ... }:
{
  flake.nixosModules.keyboard =
    {
      config,
      pkgs,
      ...
    }:
    {
      services.keyd = {
        enable = true;

        keyboards.default = {
          ids = [ "*" ];
          settings = {
            main = {
              # Treat held Caps Lock as Hyper: Ctrl+Alt+Meta+Shift.
              capslock = "overload(hyper, C-A-M-S-space)";
            };

            "hyper:C-A-M-S" = {
              # Close the focused window without relying on KWin's shortcut handling.
              q = "A-f4";
            };
          };
        };
      };
    };
}
