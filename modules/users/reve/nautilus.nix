# Nautilus file manager for reve (package only, no GNOME desktop).
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nautilus ];
      home.sessionVariables.EXPLORER = "nautilus";
    };
}
