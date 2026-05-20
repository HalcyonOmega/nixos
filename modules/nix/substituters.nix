{ inputs, ... }:
{
  flake.nixosModules.substituters =
    {
      inputs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.nexos.performance;
    in
    {
      nix.settings = {
        substituters = [
          # High priority since it's almost always used
          "https://cache.nixos.org?priority=10"

          "https://ezkea.cachix.org"
          "https://helix.cachix.org"
          "https://ghostty.cachix.org"
          "https://nix-community.cachix.org"
          "https://nix-gaming.cachix.org"
          "https://vicinae.cachix.org"
          "https://yazi.cachix.org"
        ]
        ++ lib.optionals cfg.cachyosKernelCache [
          "https://attic.xuyh0120.win/lantian"
          "https://cache.garnix.io"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

          "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
          "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
          "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
          "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
        ]
        ++ lib.optionals cfg.cachyosKernelCache [
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };
    };
}
