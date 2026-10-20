# Owned Hyprland enable for reve. Session binds/appearance come from Ambxst.
{
  flake.modules.homeManager."users/reve" = {
    wayland.windowManager.hyprland.enable = true;
  };
}
