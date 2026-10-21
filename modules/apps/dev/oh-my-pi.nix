{ inputs, ... }:
{
  flake.nixosModules.oh-my-pi =
    { pkgs, username, ... }:
    let
      # Built from the upstream source tag pinned by the `oh-my-pi` flake input
      # (currently v18.12.5) so the local patches below apply.
      upstream = inputs.oh-my-pi.packages.${pkgs.stdenv.hostPlatform.system}.default;
      package = upstream.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          # Custom answers in the ask dialog show the whole question and every
          # option while typing, and keep the draft when the prompt is cancelled.
          ./patches/omp-ask-custom-answer-context.patch
          # Collab hosting for long sessions: joins and reconnects receive only
          # the latest history (collab.historyEntries, ~3 MB cap) instead of the
          # whole transcript; guests see live subagents plus a few recent ones
          # (collab.recentAgents) instead of every agent ever spawned; and
          # superseded live frames (stream updates, state, roster, progress)
          # are coalesced so a slow relay no longer overflows the send backlog
          # and ends the room.
          ./patches/omp-collab-host-stability.patch
        ];
      });

      # Pip's own build: the shared package plus Pip-only behavior patches.
      # Reset-order account routing: each request goes to the account whose
      # weekly window resets soonest and is not at 100% on its 5h or weekly
      # limit; at 100% it moves to the next-soonest reset. Automatic session
      # pins no longer hold a session on a later-resetting account. Plain
      # `omp` keeps upstream routing.
      pipPackage = package.overrideAttrs (old: {
        pname = "pip-omp";
        patches = (old.patches or [ ]) ++ [ ./pip/patches/account-routing.patch ];
      });

      # Patched collab browser client (liveness probe + instant reconnect on
      # tab wake / network return, stalled-sync redial, active/recent agent
      # rail, sync progress bar). Same source and bun deps as the CLI; only the
      # static site is built.
      collabWeb = upstream.overrideAttrs (old: {
        pname = "omp-collab-web";
        patches = (old.patches or [ ]) ++ [ ./patches/omp-collab-web.patch ];
        buildPhase = ''
          runHook preBuild
          bun --cwd=packages/collab-web run build
          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall
          cp -r packages/collab-web/dist "$out"
          runHook postInstall
        '';
        preFixup = "";
        postFixup = "";
        preInstallCheck = "";
        doInstallCheck = false;
        meta = old.meta // {
          description = "omp collab browser guest client (static site)";
        };
      });
      collabWebPort = 7468;

      pipConfig = pkgs.writeText "pip-omp-config.yml" (builtins.readFile ./pip/config.yml);
      pipSystemPrompt = pkgs.writeText "pip-omp-system.md" (builtins.readFile ./pip/SYSTEM.md);
      pipToolbox = pkgs.writeText "pip-omp-toolbox.ts" (builtins.readFile ./pip/toolbox.ts);
      pip = pkgs.writeShellApplication {
        name = "pip";
        text = ''
          sessions="$HOME/.local/state/pip-omp/sessions"
          mkdir -p "$sessions"

          exec ${pipPackage}/bin/omp \
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

        # omp reads models.yml only from the shared agent dir, so this applies to
        # Pip and plain omp alike.
        home.file.".omp/agent/models.yml".source = ./pip/models.yml;

        programs.oh-my-pi = {
          enable = true;
          inherit package;
        };

        # Serves the patched collab web client on loopback. Any collab link
        # works here: http://localhost:7468/#<link> (the room key stays in the
        # fragment). Set collab.webUrl to this origin to make /collab print it.
        systemd.user.services.omp-collab-web = {
          Unit.Description = "omp collab web client (patched, loopback only)";
          Install.WantedBy = [ "default.target" ];
          Service = {
            ExecStart = "${pkgs.static-web-server}/bin/static-web-server --host 127.0.0.1 --port ${toString collabWebPort} --root ${collabWeb} --log-level warn";
            Restart = "on-failure";
          };
        };
      };
    };
}
