{ inputs, ... }:
{
  flake.nixosModules.oh-my-pi =
    { pkgs, username, ... }:
    let
      version = "18.2.7";
      package = inputs.omp-flake.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs {
        inherit version;
        src = pkgs.fetchurl {
          url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-linux-x64";
          hash = "sha256-HCjtZlZuyrq4FFFM/mJrSv9ZgbfKmJJHe0ZVD+a22Ds=";
        };
      };
      pipConfig = pkgs.writeText "pip-omp-config.yml" (builtins.readFile ./pip/config.yml);
      pipSystemPrompt = pkgs.writeText "pip-omp-system.md" (builtins.readFile ./pip/SYSTEM.md);
      pipToolbox = pkgs.writeText "pip-omp-toolbox.ts" (builtins.readFile ./pip/toolbox.ts);
      pip = pkgs.writeShellApplication {
        name = "pip";
        text = ''
          sessions="$HOME/.local/state/pip-omp/sessions"
          mkdir -p "$sessions"

          exec ${package}/bin/omp \
            --config ${pipConfig} \
            --system-prompt ${pipSystemPrompt} \
            --session-dir "$sessions" \
            --no-extensions \
            --extension ${pipToolbox} \
            --no-rules \
            --no-title \
            "$@"
        '';
      };
    in
    {
      home-manager.users.${username} = {
        imports = [ inputs.omp-flake.homeManagerModules.default ];

        home.packages = [ pip ];

        programs.oh-my-pi = {
          enable = true;
          inherit package;
        };
      };
    };
}
