{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.packageTemplate = pkgs.stdenv.mkDerivation {
        pname = "packageTemplate";
        version = "0.0.1";
      };
    };
}
