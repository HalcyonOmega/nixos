{ inputs, ... }:
{
  flake.nixosModules.brave =
    {
      pkgs,
      username,
      ...
    }:
    {
      home-manager.users.${username} =
        { lib, ... }:
        {
          home.packages = [
            pkgs.nssTools
            pkgs.opensc
          ];

          home.activation.registerOpenScForChromium = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            nssdb="$HOME/.pki/nssdb"
            mkdir -p "$nssdb"

            if ! ${pkgs.nssTools}/bin/certutil -d "sql:$nssdb" -L >/dev/null 2>&1; then
              ${pkgs.nssTools}/bin/certutil -d "sql:$nssdb" -N --empty-password
            fi

            if ${pkgs.nssTools}/bin/modutil -dbdir "sql:$nssdb" -list |
              ${pkgs.gnugrep}/bin/grep -q '^ *OpenSC PKCS#11'; then
              ${pkgs.nssTools}/bin/modutil -dbdir "sql:$nssdb" -delete "OpenSC PKCS#11" -force
            fi

            ${pkgs.nssTools}/bin/modutil \
              -dbdir "sql:$nssdb" \
              -add "OpenSC PKCS#11" \
              -libfile "${pkgs.opensc}/lib/pkcs11/opensc-pkcs11.so" \
              -force
          '';

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
