{ inputs, ... }:
let
  # Nixpkgs `nerd-fonts.atkynson-mono` is Nerd Fonts v3.4.0’s AtkinsonHyperlegibleMono
  # release (tar.xz from the same GitHub release as AtkinsonHyperlegibleMono.zip).
  # Upstream metadata uses the typo name "AtkynsonMono"; real face is Atkinson Hyperlegible Mono.
  hyperlegibleMonoNerd = "AtkynsonMono Nerd Font Mono";
  hyperlegibleNext = "Atkinson Hyperlegible Next";
in
{
  flake.nixosModules.fonts =
    { pkgs, username, lib, ... }:
    {
      # Plasma 6’s stock module adds Noto + Hack; force a single stack for consistency.
      fonts.enableDefaultPackages = lib.mkForce false;

      fonts.packages = lib.mkForce (
        with pkgs; [
          atkinson-hyperlegible-next
          nerd-fonts.atkynson-mono
        ]
      );

      fonts.fontconfig.defaultFonts = lib.mkForce {
        serif = [ hyperlegibleNext ];
        sansSerif = [ hyperlegibleNext ];
        monospace = [ hyperlegibleMonoNerd ];
        emoji = [ hyperlegibleNext ];
      };

      services.desktopManager.plasma6.notoPackage = pkgs.atkinson-hyperlegible-next;

      home-manager.users.${username} = {
        fonts.fontconfig.enable = true;
      };
    };
}
