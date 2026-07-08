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
      # `jet`/`jetpack` on PATH exec the freshest locally-built debug binary
      # (main checkout or any agent worktree) instead of a Nix-store build
      # that goes stale the moment the source changes. `cargo build` in any
      # checkout is immediately live; no nixos-rebuild needed per change.
      latest =
        bin:
        pkgs.writeShellScriptBin bin ''
          newest=""
          for candidate in ${repo}/target/debug/${bin} ${repo}/.claude/worktrees/*/target/debug/${bin}; do
            [ -x "$candidate" ] || continue
            if [ -z "$newest" ] || [ "$candidate" -nt "$newest" ]; then
              newest="$candidate"
            fi
          done
          if [ -z "$newest" ]; then
            echo "${bin}: no debug build found — run 'cargo build' in ${repo}" >&2
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
