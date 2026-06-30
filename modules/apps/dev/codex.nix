{ inputs, ... }:
{
  flake.nixosModules.codex =
    {
      inputs,
      system,
      username,
      ...
    }:
    let
      # nixpkgs-unstable lags behind codex releases; bump from master (0.142.2) to latest tag.
      pkgsCodex = import inputs.nixpkgs-plasma-beta {
        inherit system;
        config.allowUnfree = true;
      };

      codex = pkgsCodex.codex.overrideAttrs (_: {
        version = "0.142.3";
        src = pkgsCodex.fetchFromGitHub {
          owner = "openai";
          repo = "codex";
          tag = "rust-v0.142.3";
          hash = "sha256-dxkyaWpgzqpAVFojDYQ6JpMPNBIX+d7xjIyLic4Cs8A=";
        };
      });
    in
    {
      home-manager.users.${username} = {
        home.packages = [ codex ];
      };
    };
}
