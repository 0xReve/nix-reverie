# GameMode + Gamescope. Pair with steam on gaming hosts.
{
  flake.modules.nixos.gaming = {
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
  };
}
