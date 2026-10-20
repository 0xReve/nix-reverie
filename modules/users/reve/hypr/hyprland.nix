# Owned Hyprland enable for reve. Session binds/appearance come from Ambxst.
{
  flake.modules.homeManager."users/reve" = {
    wayland.windowManager.hyprland = {
      enable = true;
      # Ambxst + extraConfig use hyprlang; keep legacy default under HM 26.05.
      configType = "hyprlang";
    };
  };
}
