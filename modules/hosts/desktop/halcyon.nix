# { inputs, self, ... }:
# {
#   flake.nixosConfiguration.halcyon = inputs.nixpkgs.lib.nixosSystem {
#     inherit system;
#     modules = [
#       # self.nixosModules.moduleTemplate
#       self.nixosModules.halcyonModule
#       home-manager.nixosModules.home-manager
#       {
#         home-manager.backupFileExtension = "backup";
#         home-manager.useUserPackages = true;
#         home-manager.useGlobalPkgs = true;
#         home-manager.sharedModules = [
#           plasma-manager.homeModules.plasma-manager
#           nixcord.homeModules.nixcord
#           nix-flatpak.homeManagerModules.nix-flatpak
#           vicinae.homeManagerModules.default
#         ];
#         home-manager.extraSpecialArgs = {
#           inherit
#             inputs
#             username
#             githubEmail
#             githubUsername
#             ;
#           host = "halcyon";
#         };
#         home-manager.users.${username} = {
#           home.stateVersion = "25.11";
#         };
#       }
#           ];
#     ];
            
#           specialArgs = commonArgs // {
#             host = "halcyon";
#           };
#         };

        
#   };

#   flake.nixosModules.halcyonModule =
#     { pkgs, ... }:
#     {
#       imports = [
#     ./hardware-configuration.nix
#     ./../../modules
#   ];

#       time.timeZone = "America/New_York";
#       i18n.defaultLocale = "en_US.UTF-8";
#       i18n.extraLocaleSettings = {
#         LC_ADDRESS = "en_US.UTF-8";
#         LC_IDENTIFICATION = "en_US.UTF-8";
#         LC_MEASUREMENT = "en_US.UTF-8";
#         LC_MONETARY = "en_US.UTF-8";
#         LC_NAME = "en_US.UTF-8";
#         LC_NUMERIC = "en_US.UTF-8";
#         LC_PAPER = "en_US.UTF-8";
#         LC_TELEPHONE = "en_US.UTF-8";
#         LC_TIME = "en_US.UTF-8";
#       };
#     };
# }
