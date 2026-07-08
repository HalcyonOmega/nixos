{ inputs, ... }:
{
  flake.nixosModules.claude =
    { system, username, ... }:
    {
      home-manager.users.${username} = {
        # sadjow/claude-code-nix tracks upstream hourly; bump via `nix flake update claude-code-nix`.
        home.packages = [ inputs.claude-code-nix.packages.${system}.default ];
      };
    };
}
