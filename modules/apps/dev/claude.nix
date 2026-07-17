{ inputs, ... }:
{
  flake.nixosModules.claude =
    {
      pkgs,
      system,
      username,
      ...
    }:
    let
      claude = inputs.claude-code-nix.packages.${system}.default;
      mkClaudeGateway =
        { name, model }:
        pkgs.writeShellApplication {
          inherit name;
          text = ''
            config="$HOME/.cli-proxy-api/config.yaml"
            if [[ ! -r "$config" ]]; then
              echo "CPA config not readable: $config" >&2
              exit 1
            fi

            api_key="$(${pkgs.gawk}/bin/awk '
              /^api-keys:/ { in_keys = 1; next }
              in_keys && /^[^[:space:]]/ { exit }
              in_keys && /^[[:space:]]*-/ {
                key = $0
                sub(/^[[:space:]]*-[[:space:]]*"?/, "", key)
                sub(/"[[:space:]]*$/, "", key)
                print key
                exit
              }
            ' "$config")"
            if [[ -z "$api_key" ]]; then
              echo "CPA API key missing from $config" >&2
              exit 1
            fi

            export ANTHROPIC_BASE_URL="http://127.0.0.1:8317"
            export ANTHROPIC_AUTH_TOKEN="$api_key"
            export ANTHROPIC_MODEL="${model}"
            export ANTHROPIC_SMALL_FAST_MODEL="${model}"
            export CLAUDE_CODE_SUBAGENT_MODEL="${model}"

            exec ${claude}/bin/claude --model "${model}" "$@"
          '';
        };
      claudeKimi = mkClaudeGateway {
        name = "claude-kimi";
        model = "kimi-k3";
      };
      claudeSol = mkClaudeGateway {
        name = "claude-sol";
        model = "gpt-5.6-sol";
      };
    in
    {
      home-manager.users.${username} = {
        # sadjow/claude-code-nix tracks upstream hourly; bump via `nix flake update claude-code-nix`.
        home.packages = [
          claude
          claudeKimi
          claudeSol
        ];
      };
    };
}
