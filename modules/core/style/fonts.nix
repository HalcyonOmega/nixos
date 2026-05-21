{ ... }:
let
  jetBrainsMonoNerd = "JetBrainsMono Nerd Font Mono";
  hyperlegibleNext = "Atkinson Hyperlegible Next";
in
{
  flake.nixosModules.fonts =
    {
      pkgs,
      username,
      lib,
      ...
    }:
    {
      # Plasma 6’s stock module adds Noto + Hack; force a single stack for consistency.
      fonts.enableDefaultPackages = lib.mkForce false;

      fonts.packages = lib.mkForce (
        with pkgs;
        [
          atkinson-hyperlegible-next
          nerd-fonts.jetbrains-mono
        ]
      );

      fonts.fontconfig.defaultFonts = lib.mkForce {
        serif = [ hyperlegibleNext ];
        sansSerif = [ hyperlegibleNext ];
        monospace = [ jetBrainsMonoNerd ];
        emoji = [ hyperlegibleNext ];
      };

      services.desktopManager.plasma6.notoPackage = pkgs.atkinson-hyperlegible-next;

      home-manager.users.${username} = {
        fonts.fontconfig.enable = true;
      };
    };
}
