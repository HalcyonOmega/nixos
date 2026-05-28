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
            module_name="OpenSC PKCS#11"
            module_path="${pkgs.opensc}/lib/pkcs11/opensc-pkcs11.so"

            mkdir -p "$nssdb"

            if ! ${pkgs.nssTools}/bin/certutil -d "sql:$nssdb" -L >/dev/null 2>&1; then
              ${pkgs.nssTools}/bin/certutil -d "sql:$nssdb" -N --empty-password
            fi

            if ! ${pkgs.gnugrep}/bin/grep -Fxq "library=$module_path" "$nssdb/pkcs11.txt" ||
              ! ${pkgs.nssTools}/bin/modutil -dbdir "sql:$nssdb" -list |
                ${pkgs.gnugrep}/bin/grep -Eq "^ *[0-9]+\\. $module_name$"; then
              if ${pkgs.nssTools}/bin/modutil -dbdir "sql:$nssdb" -list |
                ${pkgs.gnugrep}/bin/grep -Eq "^ *[0-9]+\\. $module_name$"; then
                ${pkgs.nssTools}/bin/modutil -dbdir "sql:$nssdb" -delete "$module_name" -force
              fi

              ${pkgs.nssTools}/bin/modutil \
                -dbdir "sql:$nssdb" \
                -add "$module_name" \
                -libfile "$module_path" \
                -force
            fi
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
