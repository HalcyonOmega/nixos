{ inputs, self, ... }:
{
  flake.nixosModules.shells =
    { ... }:
    {
      imports = [
        # self.nixosModules.fish
      ];
    };
}
