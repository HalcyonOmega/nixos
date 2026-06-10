{ ... }:
{
  flake.nixosModules.nexos-manager =
    {
      inputs,
      pkgs,
      system,
      username,
      ...
    }:
    let
      nexosPackages = inputs.nexos.packages.${system};
    in
    {
      nixpkgs.overlays = [
        (_final: _prev: {
          nex = nexosPackages.nex;
          nexos-manager = nexosPackages.nexos-manager;
        })
      ];

      home-manager.users.${username} = {
        home.packages = [
          pkgs.nex
          pkgs.nexos-manager
        ];
      };

      environment.sessionVariables.NEX_FLAKE = "/home/${username}/nixos";
    };
}
