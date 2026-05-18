{ inputs, ... }:
{
  flake.nixosModules.brave =
    {
      pkgs,
      username,
      ...
    }:
    {
      home-manager.users.${username} = {
        # home.packages = [ pkgs.brave ];
        # home.packages = [ inputs.brave-origin.packages.${pkgs.system}.default ];

        programs.brave = {
          enable = true;
          package = inputs.brave-origin.packages.${pkgs.system}.default;

          commandLineArgs = [
            "--force-dark-mode"
            "--disable-features=PasswordManagerOnboarding"
            "--disable-features=AutofillEnableAccountWalletStorage"
          ];

          extensions = [
            { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
            { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
            { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
          ];
        };
      };
    };
}
