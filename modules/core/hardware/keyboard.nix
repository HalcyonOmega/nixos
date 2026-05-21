{ ... }:
{
  flake.nixosModules.keyboard = { ... }:
    {
      services.keyd = {
        enable = true;

        keyboards.default = {
          ids = [ "*" ];
          settings = {
            main = {
              # Treat held Caps Lock as Hyper: Ctrl+Alt+Meta+Shift.
              capslock = "overload(hyper, C-A-M-S-space)";
              # Treat held Meta as a normal modifier, but tap it to show Expose.
              leftmeta = "overload(meta, M-space)";
              rightmeta = "overload(meta, M-space)";
            };

            "hyper:C-A-M-S" = {
              # Close the focused window without relying on KWin's shortcut handling.
              q = "A-f4";
            };

            "meta:M" = { };
          };
        };
      };
    };
}
