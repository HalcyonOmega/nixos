{ inputs, ... }:
{
  flake.nixosModules.ghostty =
    {
      pkgs,
      username,
      terminalTheme,
      ...
    }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.ghostty ];

        programs.ghostty = {
          enable = true;

          settings = terminalTheme.ghostty // {
            background-opacity = 0.8;
            background-opacity-cells = true;

            font-family = "NotoSansM Nerd Font Mono";
            font-size = 13;

            cursor-style = "bar";

            window-vsync = false;
            window-height = "30";
            window-width = "115";

            quit-after-last-window-closed = false;

            desktop-notifications = true;

            # custom-shader-animation = "always";
            # custom-shader = [ "${ghosttyShaders}/cursor_sweep.glsl" ];
          };

          enableFishIntegration = true;
          installBatSyntax = true;
          installVimSyntax = true;

        };

        # systemd.user.services.ghostty = {
        #   Unit = {
        #     Description = "ghostty daemon";
        #     After = [
        #       "graphical-session.target"
        #       "dbus.socket"
        #     ];
        #     Requires = [ "dbus.socket" ];
        #   };

        #   Install.WantedBy = [ "graphical-session.target" ];

        # Service = {
        #   Type = "notify-reload";
        #   ReloadSignal = "SIGUSR2";
        #   BusName = "com.mitchellh.ghostty";
        #   ExecStart = "${config.programs.ghostty.package}/bin/ghostty --gtk-single-instance=true --initial-window=false";
        # };
        # };
      };
    };
}
