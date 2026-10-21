# Session apps for reve: launch once and pin to workspaces (old Hypr layout).
# 1 steam · 2 zen + equibop · 3 spotify
{
  flake.modules.homeManager."users/reve" = {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "steam"
        "zen-twilight"
        "equibop"
        "spotify"
      ];

      # Hyprland 0.53+ match syntax (was windowrulev2 in the old tree).
      windowrule = [
        "workspace 1, match:class ^(steam)$"
        "workspace 2, match:class ^(zen|zen-browser|zen-twilight)$"
        "workspace 2, match:class ^(equibop|vesktop)$"
        "workspace 3, match:class ^([Ss]potify)$"
      ];
    };
  };
}
