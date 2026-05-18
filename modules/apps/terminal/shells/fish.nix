{ inputs, ... }:
{
  flake.nixosModules.fish =
    {
      pkgs,
      username,
      terminalTheme,
      ...
    }:
    let
      c = terminalTheme.colors;
    in
    {
      home-manager.users.${username} = {
        home.packages = [
          pkgs.fish
        ];

        programs.fish = {
          enable = true;
          interactiveShellInit = ''
            set fish_greeting

            # Reactor (base16) — same palette as assets/themes/base16/reactor.yaml (via terminalTheme)
            set -g fish_color_normal ${c.foreground}
            set -g fish_color_command ${c.blue}
            set -g fish_color_keyword ${c.magenta}
            set -g fish_color_quote ${c.green}
            set -g fish_color_redirection ${c.yellow}
            set -g fish_color_end ${c.foreground}
            set -g fish_color_error ${c.error}
            set -g fish_color_param ${c.magenta}
            set -g fish_color_comment ${c.comment}
            set -g fish_color_selection ${c."selection-foreground"} --background=${c."selection-background"}
            set -g fish_color_operator ${c.cyan}
            set -g fish_color_escape ${c.magenta}
            set -g fish_color_autosuggestion ${c.brightBlack}
            set -g fish_color_cancel ${c.red}
            set -g fish_color_cwd ${c.blue}
            set -g fish_color_user ${c.yellow}
            set -g fish_color_host ${c.green}
            set -g fish_color_host_remote ${c.brown}
            set -g fish_color_match ${c.cyan}
            set -g fish_color_search_match ${c.black} --background=${c.yellow}

            set -g fish_pager_color_progress ${c.cyan}
            set -g fish_pager_color_completion ${c.foreground}
            set -g fish_pager_color_description ${c.yellow}
            set -g fish_pager_color_prefix ${c.blue} --bold
            set -g fish_pager_color_comment ${c.comment}
          '';
        };
      };

      programs.fish = {
        enable = true;
        useBabelfish = true;
      };
    };
}
