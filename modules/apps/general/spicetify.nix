{ inputs, ... }:
{
  flake.nixosModules.spicetify =
    { pkgs, username, ... }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      home-manager.users.${username} = {
        imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

        programs.spicetify = {
          enable = true;
          theme = spicePkgs.themes.catppuccin;
          colorScheme = "mocha";
          enabledExtensions = with spicePkgs.extensions; [
            adblockify
            hidePodcasts
            shuffle
          ];
        };
      };
    };
}
