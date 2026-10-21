{ ... }:
{
  flake.nixosModules.jetlang =
    {
      pkgs,
      username,
      ...
    }:
    let
      repo = "/home/${username}/Projects/Github/jet";
      # `jet`/`jetpack` on PATH exec the freshest locally-built binary of this
      # repo instead of a Nix-store build that goes stale the moment the source
      # changes: debug or release, from the main checkout, any agent worktree,
      # or a checkout-owned scratch target (Tools/agent/jet-env builds there).
      # A build anywhere is immediately live; no nixos-rebuild needed per change.
      latest =
        bin:
        pkgs.writeShellScriptBin bin ''
          newest=""
          for candidate in \
            ${repo}/target/{debug,release}/${bin} \
            ${repo}/.agent-worktrees/*/target/{debug,release}/${bin} \
            ${repo}/.claude/worktrees/*/target/{debug,release}/${bin} \
            /mnt/jetscratch/targets/*/{debug,release}/${bin} \
            /home/${username}/.cache/jet-dev/targets/*/{debug,release}/${bin}; do
            [ -f "$candidate" ] && [ -x "$candidate" ] || continue
            if [ -z "$newest" ] || [ "$candidate" -nt "$newest" ]; then
              newest="$candidate"
            fi
          done
          if [ -z "$newest" ]; then
            echo "${bin}: no build found — run 'cargo build' in ${repo}" >&2
            exit 127
          fi
          exec "$newest" "$@"
        '';
    in
    {
      home-manager.users.${username} = {
        home.packages = [
          (latest "jet")
          (latest "jetpack")
        ];
      };
    };
}
