{ inputs, ... }:
{
  flake.nixosModules.handy =
    { pkgs, username, ... }:
    let
      handy = inputs.nixpkgs-handy.legacyPackages.${pkgs.stdenv.hostPlatform.system}.handy;
    in
    {
      users.users.${username}.extraGroups = [ "ydotool" ];

      home-manager.users.${username} = {
        home.packages = [ handy ];

        programs.plasma.hotkeys.commands."toggle-handy-transcription" = {
          name = "Toggle Handy Dictation";
          key = "Meta+Ctrl+Alt+Shift+D";
          command = "${handy}/bin/handy --toggle-transcription";
        };
      };
    };
}
