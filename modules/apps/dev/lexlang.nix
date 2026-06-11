{ inputs, ... }:
{
  flake.nixosModules.lexlang =
    {
      inputs,
      system,
      username,
      ...
    }:
    let
      lex = inputs.lexlang.packages.${system}.lex;
    in
    {
      home-manager.users.${username} = {
        home.packages = [
          lex
        ];
      };
    };
}
