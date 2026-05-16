{ inputs, ... }:
{
  flake.nixosModules.sched-ext =
    { ... }:
    {
      services.scx = {
        enable = false;
        scheduler = "scx_mitosis";
      };
    };
}
