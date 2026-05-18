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
        home.packages = [ pkgs.brave ];

        programs.brave = {
          enable = true;

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
