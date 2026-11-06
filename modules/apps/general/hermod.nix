{ inputs, ... }:
{
  # Hermod: personal Gmail/iCloud mail client (~/Projects/Github/Hermod).
  # Default mailto: handler (see core/xdg-mimes.nix); starts in the tray at
  # login so new-mail notifications arrive without opening the window.
  flake.nixosModules.hermod =
    {
      inputs,
      system,
      username,
      ...
    }:
    let
      hermod = inputs.hermod.packages.${system}.default;
    in
    {
      home-manager.users.${username} = {
        home.packages = [ hermod ];

        xdg.configFile."autostart/hermod.desktop".text = ''
          [Desktop Entry]
          Type=Application
          Name=Hermod
          Comment=Mail in the background (tray)
          Exec=${hermod}/bin/hermod --hidden
          Icon=hermod
          X-KDE-autostart-phase=2
        '';
      };
    };
}
