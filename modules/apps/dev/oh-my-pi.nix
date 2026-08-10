{ inputs, ... }:
{
  flake.nixosModules.oh-my-pi =
    { username, ... }:
    {
      home-manager.users.${username} = {
        imports = [ inputs.omp-flake.homeManagerModules.default ];

        # Upstream binary releases via cernoh/omp-flake; bump with
        # `nix flake update omp-flake`.
        programs.oh-my-pi.enable = true;
      };
    };
}
