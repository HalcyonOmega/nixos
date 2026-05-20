{ inputs, ... }:
{
  flake.nixosModules.home-manager =
    {
      githubEmail,
      githubUsername,
      host,
      pkgs-stable,
      username,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager.backupFileExtension = "backup";
      home-manager.useUserPackages = true;
      home-manager.useGlobalPkgs = true;

      home-manager.sharedModules = [
        inputs.plasma-manager.homeModules.plasma-manager
        inputs.nixcord.homeModules.nixcord
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
        inputs.vicinae.homeManagerModules.default
      ];

      home-manager.extraSpecialArgs = {
        inherit
          inputs
          username
          githubEmail
          githubUsername
          pkgs-stable
          host
          ;
      };

      home-manager.users.${username} = {
        home.stateVersion = "26.05";
        programs.home-manager.enable = true;
      };
    };
}
