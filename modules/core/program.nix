{ ... }:
{
  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryFlavor = "";
    };
    nix-ld.enable = true;
    # programs.nix-ld.libraries = with pkgs; [ ];
  };
}
