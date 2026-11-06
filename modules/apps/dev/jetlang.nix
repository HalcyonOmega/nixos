{ ... }:
{
  flake.nixosModules.jetlang =
    {
      pkgs,
      username,
      ...
    }:
    let
      # `jet` on PATH is the current Jet release: the a0_NNN directory that
      # `$JET_SEEDS/current` (default ~/.local/share/jet-seeds/current) names,
      # read at every run. Tools/agent/release-compiler.mjs in the Jet repo
      # cuts releases; `jet-use a0_NNN` moves `current` (or rolls it back),
      # so no nixos-rebuild is needed per release. `jet-which` names it.
      release = ''
        seeds="''${JET_SEEDS:-$HOME/.local/share/jet-seeds}"
        c="$(readlink -f "$seeds/current" 2>/dev/null || true)"
        if [ -z "$c" ] || [ ! -x "$c/jet" ] || [ ! -f "$c/IDENTITY" ]; then
          echo "$(basename "$0"): no Jet release at $seeds/current (pick one with jet-use a0_NNN)" >&2
          exit 127
        fi
        JET_COMPILER_IDENTITY="$(cat "$c/IDENTITY")"
        JET_TOOLCHAIN_ROOT="$c/toolchain"
        export JET_COMPILER_IDENTITY JET_TOOLCHAIN_ROOT
        # The compiler recurses deeply; the seed launchers ran it with 1 GiB.
        ulimit -s unlimited 2>/dev/null || ulimit -s 1048576 2>/dev/null || true
      '';
      jet = pkgs.writeShellScriptBin "jet" ''
        ${release}
        exec "$c/jet" "$@"
      '';
      # jet runs the `jetpack` engine from beside its own executable first, so
      # a release that ships one is also what `jet` dispatches to.
      jetpack = pkgs.writeShellScriptBin "jetpack" ''
        ${release}
        if [ ! -x "$c/jetpack" ]; then
          echo "jetpack: release $(basename "$c") ships no Jet-built jetpack engine; releases cut by Tools/agent/release-compiler.mjs carry one" >&2
          exit 127
        fi
        exec "$c/jetpack" "$@"
      '';
      jet-which = pkgs.writeShellScriptBin "jet-which" ''
        seeds="''${JET_SEEDS:-$HOME/.local/share/jet-seeds}"
        c="$(readlink -f "$seeds/current" 2>/dev/null || true)"
        [ -n "$c" ] && [ -d "$c" ] || { echo "jet-which: no Jet release at $seeds/current" >&2; exit 1; }
        label="$(sed -n 's/^LABEL="\(.*\)"$/\1/p' "$seeds/current.env" 2>/dev/null)"
        commit="$(awk 'NR==1{print $1}' "$c/SOURCE" 2>/dev/null)"
        if [ -f "$c/RELEASE.json" ]; then
          evidence="$(${pkgs.jq}/bin/jq -r '"release-compiler.mjs \(.verdict) (\(.scope)): \(.gains.total) gains, \(.lost | length) lost; \(.checks | map("\(.check) \(.status)") | join(", "))"' "$c/RELEASE.json")"
        elif [ -f "$c/ROTATION.md" ]; then
          evidence="rotation $(sed -n 's/^VERDICT: //p' "$c/ROTATION.md" | head -1)"
        else
          evidence="$(cut -d' ' -f2- "$c/SOURCE" 2>/dev/null)"
        fi
        printf 'release   %s\nlabel     %s\ncommit    %s\nevidence  %s\npath      %s\nidentity  %s\n' \
          "$(basename "$c")" "''${label:-none}" "''${commit:-unknown}" "''${evidence:-none}" "$c/jet" "$(cat "$c/IDENTITY" 2>/dev/null)"
      '';
      # jet-use a0_NNN: make a release current (a roll forward or back). Only a
      # release whose evidence passed qualifies: RELEASE.json verdict PASS over
      # the full suites, a rotation VERDICT of ready, or (a0_007..a0_010, before
      # either existed) a SOURCE record of the fixed point.
      jet-use = pkgs.writeShellScriptBin "jet-use" ''
        set -eu
        seeds="''${JET_SEEDS:-$HOME/.local/share/jet-seeds}"
        name="''${1:-}"
        refuse() { echo "jet-use: refuse $name: $*" >&2; exit 1; }
        if [ $# -ne 1 ] || ! [[ "$name" =~ ^a0_[0-9]{3}$ ]]; then
          echo "usage: jet-use a0_NNN" >&2
          exit 64
        fi
        d="$seeds/$name"
        [ -d "$d" ] || refuse "no $d"
        for f in jet IDENTITY toolchain SHA256SUMS; do
          [ -e "$d/$f" ] || refuse "it has no $f"
        done
        if [ -f "$d/RELEASE.json" ]; then
          ${pkgs.jq}/bin/jq -e '.verdict == "PASS" and .scope == "full"' "$d/RELEASE.json" >/dev/null \
            || refuse "RELEASE.json is $(${pkgs.jq}/bin/jq -r '"\(.verdict) (\(.scope))"' "$d/RELEASE.json"), not PASS over the full suites"
        elif [ -f "$d/ROTATION.md" ]; then
          grep -q '^VERDICT: ready' "$d/ROTATION.md" || refuse "its rotation $(grep -m1 '^VERDICT' "$d/ROTATION.md" || echo 'has no VERDICT')"
        else
          grep -qi 'fixed point' "$d/SOURCE" 2>/dev/null || refuse "it records no passing evidence"
        fi
        (cd "$d" && sha256sum --quiet --strict -c SHA256SUMS) || refuse "its files do not match SHA256SUMS"
        if [ -f "$d/current.env" ]; then
          cp "$d/current.env" "$seeds/current.env.new"
        else
          label="$name ($(cut -d' ' -f2- "$d/SOURCE" 2>/dev/null | tr -d '"' | sed 's/^(//; s/)$//'))"
          printf '# Newest verified self-hosted compiler (set by jet-use).\nLABEL="%s"\nJET=%s/jet\nJET_IDENTITY=%s\nSOURCE=%s/toolchain\n' \
            "$label" "$d" "$(cat "$d/IDENTITY")" "$d" > "$seeds/current.env.new"
        fi
        ln -sfn "$name" "$seeds/current.new"
        mv -T "$seeds/current.new" "$seeds/current"
        mv "$seeds/current.env.new" "$seeds/current.env"
        echo "current -> $name ($(cat "$d/IDENTITY"))"
      '';
    in
    {
      home-manager.users.${username} = {
        home.packages = [
          jet
          jetpack
          jet-which
          jet-use
        ];
      };
    };
}
