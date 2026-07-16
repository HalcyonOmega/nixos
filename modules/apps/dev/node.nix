{ inputs, ... }:
{
  flake.nixosModules.node =
    { pkgs, username, ... }:
    {
      home-manager.users.${username} = {
        # Node.js on the host PATH (includes npm) so agent tooling like the
        # Codex Claude Code plugin runs without a nix dev shell.
        home.packages = [ pkgs.nodejs ];
      };
    };
}
