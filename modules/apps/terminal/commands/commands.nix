{ inputs, self, ... }:
{
  flake.nixosModules.commands =
    { ... }:
    {
      imports = [
        self.nixosModules.nix-search

        self.nixosModules.bat
        self.nixosModules.btop
        self.nixosModules.cmatrix
        self.nixosModules.eza
        self.nixosModules.fastfetch
        self.nixosModules.fresh
        self.nixosModules.fzf
        self.nixosModules.git
        self.nixosModules.helix
        self.nixosModules.nh
        self.nixosModules.nitch
        self.nixosModules.openssl
        self.nixosModules.ripgrep
        self.nixosModules.ssh
        self.nixosModules.starship
        self.nixosModules.tealdeer
        self.nixosModules.yazi
        self.nixosModules.zoxide
      ];
    };
}

# @Nate TODO: Look into these commands
# systemPackages = with pkgs; [
#       jq
#       fd
#       xh
#       file
#       timg
#       choose
#       sd
#       rustscan
#       yt-dlp
#       sox
#       asak
#       timer
#       dig
#       mtr
#       mediainfo
#       fdupes
#       whois
#       killall
#       trashy
#       hwinfo
#       duf
#       stress
#       hdparm
#       recode
#       jpegoptim
#       pass
#       tango
#       npm-check-updates
#       microfetch
#       onefetch
#       scc
#       genact
#       sanctity
#       asciiquarium-transparent
#       cmatrix
#       gdu
#       hexyl
#       p7zip
#       unar
#       rsync
#       rclone
#       megacmd
#       ffmpeg
#       imagemagick
#       smartmontools
#       restic
#       zbar
#       phraze
#       lychee
#       bluetui
#       nixpkgs-review
#       nix-init
#       nix-update
#       statix
#       nvd
#       nix-search-cli
#       nix-tree
#       gcc
#       rustc
#       rustfmt
#       cargo
#       cargo-tarpaulin
#       bacon
#       clippy
#       nodejs
#       monolith
#       haylxon
#       nix-inspect
#       sherlock
#       remind
#       oxipng
#       lazydocker
#       arion
#       tabiew
#       viddy
#       jless
#       rclip
#       exiftool
#       xsubfind3r
#       all-the-package-names
#       pik
#       bottom
#       pdfminer
#       dos2unix
#       clock-rs
#       taskwarrior3
#       unflac
#       openai-whisper
#       zizmor
#       go-grip
#       eclint
#       editorconfig-checker
#       signal-cli
#       typos
#       gallery-dl
#       hydra-check
#       awscli2
#       mkbrr
#       poppler-utils
#       dejsonlz4
#       gdb
#       bun
#       json2yaml
#       gemini-cli
#       opencode
#       sqlit-tui
#       silverbullet
#     ];
