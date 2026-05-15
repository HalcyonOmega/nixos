{ inputs, self, ... }:
{
  flake.nixosConfiguration.machineTemplate = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.moduleTemplate
      self.nixosModules.machineTemplateModule
    ];
  };

  flake.nixosModules.machineTemplateModule =
    { pkgs, ... }:
    {
      boot.loader.limine.enable = true;

      environment.systemPackages = [ self.packages.${pkgs.system}.packageTemplate ];
    };
}
