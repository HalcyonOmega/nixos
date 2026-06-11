{ inputs, ... }:
{
  flake.nixosModules.jetlang =
    {
      inputs,
      system,
      username,
      ...
    }:
    let
      jet = inputs.jetlang.packages.${system}.jet;
    in
    {
      home-manager.users.${username} = {
        home.packages = [
          jet
        ];
      };
    };
}
