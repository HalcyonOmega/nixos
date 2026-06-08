{ ... }:
{
  flake.nixosModules.odysseus =
    {
      lib,
      pkgs,
      username,
      ...
    }:
    let
      llamaCpp = pkgs.llama-cpp.override {
        rocmSupport = true;
      };

      odysseus = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "odysseus";
        version = "unstable-2026-06-08";

        src = pkgs.fetchFromGitHub {
          owner = "pewdiepie-archdaemon";
          repo = "odysseus";
          rev = "main";
          hash = "sha256-kmA4Va+aGP0pePvZZhiAe0+x7PsEN9UxwcEeXppfyBs=";
        };

        python = pkgs.python3.withPackages (
          pythonPackages: with pythonPackages; [
            beautifulsoup4
            bcrypt
            caldav
            charset-normalizer
            chromadb
            croniter
            cryptography
            fastapi
            fastembed
            hf-transfer
            hf-xet
            httpx
            huggingface-hub
            icalendar
            llama-cpp-python
            markdown
            mcp
            numpy
            pillow
            pydantic
            pydantic-settings
            pypdf
            pyotp
            python-dateutil
            python-dotenv
            python-magic
            python-multipart
            qrcode
            sqlalchemy
            starlette-context
            uvicorn
            youtube-transcript-api
          ]
        );

        dontBuild = true;

        patches = [
          ./patches/odysseus-local-download-detached.patch
        ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/odysseus $out/bin
          cp -R . $out/share/odysseus

          cat > $out/bin/odysseus <<EOF
          #!${pkgs.runtimeShell}
          set -euo pipefail

          export PATH="${
            lib.makeBinPath [
              finalAttrs.python
              pkgs.nodejs
              llamaCpp
              pkgs.tmux
            ]
          }:\$PATH"
          export ODYSSEUS_SOURCE="$out/share/odysseus"
          export ODYSSEUS_HOME="\''${ODYSSEUS_HOME:-\''${XDG_DATA_HOME:-\$HOME/.local/share}/odysseus}"
          export XDG_CACHE_HOME="\''${XDG_CACHE_HOME:-\$HOME/.cache}"
          export HF_HOME="\''${HF_HOME:-\$XDG_CACHE_HOME/huggingface}"
          export HUGGINGFACE_HUB_CACHE="\''${HUGGINGFACE_HUB_CACHE:-\$HF_HOME/hub}"
          export HF_XET_CACHE="\''${HF_XET_CACHE:-\$HF_HOME/xet}"
          export HF_HUB_DISABLE_XET="\''${HF_HUB_DISABLE_XET:-1}"
          export ODYSSEUS_NIX_LLAMA_CPP_BIN="${llamaCpp}/bin"
          mkdir -p "\$HUGGINGFACE_HUB_CACHE" "\$HF_XET_CACHE/logs"

          case "\''${DEBUG:-}" in
            ""|0|1|true|false|True|False|TRUE|FALSE) ;;
            *) unset DEBUG ;;
          esac

          if [ ! -f "\$ODYSSEUS_HOME/.source-hash" ] || [ "\$(cat "\$ODYSSEUS_HOME/.source-hash")" != "${finalAttrs.version}:${finalAttrs.src.outputHash}" ]; then
            mkdir -p "\$ODYSSEUS_HOME"
            cp -R "\$ODYSSEUS_SOURCE/." "\$ODYSSEUS_HOME/"
            chmod -R u+w "\$ODYSSEUS_HOME"
            printf "%s" "${finalAttrs.version}:${finalAttrs.src.outputHash}" > "\$ODYSSEUS_HOME/.source-hash"
            rm -f "\$ODYSSEUS_HOME/.nix-setup-complete"
          fi

          cd "\$ODYSSEUS_HOME"

          if [ ! -f "\$ODYSSEUS_HOME/.nix-setup-complete" ]; then
            ODYSSEUS_SKIP_ADMIN_PROMPT=1 ${lib.getExe finalAttrs.python} setup.py
            touch "\$ODYSSEUS_HOME/.nix-setup-complete"
          fi

          exec ${lib.getExe finalAttrs.python} -m uvicorn app:app --host "\''${ODYSSEUS_HOST:-127.0.0.1}" --port "\''${ODYSSEUS_PORT:-7000}" "\$@"
          EOF
          chmod +x $out/bin/odysseus

          runHook postInstall
        '';

        meta = {
          description = "Self-hosted AI workspace";
          homepage = "https://github.com/pewdiepie-archdaemon/odysseus";
          license = lib.licenses.mit;
          mainProgram = "odysseus";
          platforms = lib.platforms.linux;
        };
      });
    in
    {
      nixpkgs.overlays = [
        (_final: _prev: {
          inherit odysseus;
        })
      ];

      home-manager.users.${username} = {
        home.packages = [
          pkgs.odysseus
          pkgs.nodejs
          pkgs.tmux
        ];
      };
    };
}
