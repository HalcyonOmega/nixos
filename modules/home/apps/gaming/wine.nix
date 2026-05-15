{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    # @Nate TODO: Considerusing "inputs.nix-gaming.packages.${pkgs.system}.wine-ge"
    home.packages = [ pkgs.wine ];
  };
}
