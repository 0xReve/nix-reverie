# Nautilus file manager for reve (package + default directory handler).
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nautilus ];
      home.sessionVariables.EXPLORER = "nautilus";

      xdg.mimeApps = {
        enable = true;
        defaultApplications."inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      };
    };
}
