{ inputs, ... }:
{
  flake.nixosModules.security =
    { ... }:
    {
      security = {
        rtkit.enable = true;
        sudo.enable = true;
      };
    };
}
