{ inputs, ... }:
{
  flake.nixosModules.system =
    { ... }:
    {
      system.stateVersion = "26.11";
    };
}
