{ inputs, ... }:
{
  flake.nixosModules.ghostty =
    {
      pkgs,
      username,
      ...
    }:
    {
      home-manager.users.${username} = {
        home.packages = [ pkgs.ghostty ];

        programs.ghostty = {
          enable = true;

          settings = {
            # background-opacity = 0.8;
            # background-opacity-cells = true;

            # cursor-style = "bar";

            window-vsync = false;
            window-height = "30";
            window-width = "115";

            quit-after-last-window-closed = false;

            desktop-notifications = true;
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
