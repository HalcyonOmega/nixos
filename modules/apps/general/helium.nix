{ inputs, ... }:
{
  flake.nixosModules.helium =
    {
      pkgs,
      username,
      ...
    }:
    {
      imports = [
        inputs.helium-flake.homeModules.default
      ];

      home-manager.users.${username} = {
        programs.helium = {
          enable = true;
          # package = inputs.helium.packages.${pkgs.system}.default;

          commandLineArgs = [
            "--force-dark-mode"
            # "--disable-features=PasswordManagerOnboarding"
            # "--disable-features=AutofillEnableAccountWalletStorage"
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
