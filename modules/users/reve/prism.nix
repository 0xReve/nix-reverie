# Prism Launcher (Minecraft) for reve.
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.prismlauncher ];
    };
}
