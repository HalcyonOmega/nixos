{ inputs, ... }:
{
  flake.nixosModules.lexlang =
    {
      inputs,
      pkgs,
      system,
      username,
      ...
    }:
    let
      lexlang = inputs.lexlang.packages.${system};
    in
    {
      nixpkgs.overlays = [
        (_final: _prev: {
          lex = lexlang.lex;
        })
      ];

      home-manager.users.${username} = {
        home.packages = [
          pkgs.lex
        ];
      };
    };
}
