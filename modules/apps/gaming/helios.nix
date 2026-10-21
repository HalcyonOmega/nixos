{ inputs, ... }:
{
  # Helios: Moonlight game-stream host (a Sunshine fork). Each Moonlight session gets its own
  # KDE virtual display at the client's resolution and only the game's audio, so the desk keeps
  # its monitors and sound. Installed Steam games show up in Moonlight automatically.
  # Web UI: https://localhost:47990.
  flake.nixosModules.helios =
    { ... }:
    {
      imports = [ inputs.helios.nixosModules.default ];

      services.helios.enable = true;
    };
}
