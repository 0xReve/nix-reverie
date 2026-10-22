# Session apps for reve: launch once and pin to workspaces (old Hypr layout).
# 1 steam · 2 zen + equibop · 3 spotify
{
  flake.modules.homeManager."users/reve" = {
    # XDPH share-picker theming + screencopy FPS cap (DMA-BUF kept; no force_shm).
    xdg.configFile."hypr/xdph.conf".text = ''
      screencopy {
          max_fps = 60
      }
    '';

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE"
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
