{ inputs, ... }:
{
  flake.nixosModules.moduleTemplate =
    { pkgs, ... }:
    {
      programs.firefox.enable = true;

      environment.systemPackages = [ pkgs.vim ];
    };
}
