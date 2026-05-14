{ ... }:
{
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./home-manager.nix
    ./logseq.nix
    ./qt-creator.nix
    ./spotify.nix
    ./vivaldi.nix
    ./xdg-mimes.nix
    ./xorg.nix

    ./dev
    ./gaming
    ./terminal
    ./utilities
  ];
}
