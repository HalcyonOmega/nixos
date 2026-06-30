{ ... }:
{
  flake.nixosModules.zed =
    {
      lib,
      pkgs,
      username,
      ...
    }:
    {
      home-manager.users.${username} = {
        stylix.targets.zed.enable = false;

        programs.zed-editor = {
          enable = true;
          package = pkgs.zed-editor;
          extraPackages = with pkgs; [
            cargo
            clippy
            nixd
            nixfmt
            rust-analyzer
            rustc
            rustfmt
            taplo
          ];
          extensions = [
            "nix"
            "toml"
          ];
          userSettings = {
            theme = "Ayu Dark";
            lsp = {
              nixd.binary.path = lib.getExe pkgs.nixd;
              rust-analyzer.binary.path = lib.getExe pkgs.rust-analyzer;
              taplo.binary.path = lib.getExe pkgs.taplo;
            };
            languages = {
              Nix = {
                language_servers = [ "nixd" ];
                formatter = {
                  external = {
                    command = lib.getExe pkgs.nixfmt;
                  };
                };
              };
              Rust = {
                language_servers = [ "rust-analyzer" ];
              };
              TOML = {
                language_servers = [ "taplo" ];
              };
            };
          };
        };
      };
    };
}
