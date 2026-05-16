{ inputs, self, ... }:
{
  flake.nixosModules.commands =
    { ... }:
    {
      imports = [
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
