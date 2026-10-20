# Owned Hyprland conf for reve. Split further under this directory as it grows.
{
  flake.modules.homeManager."users/reve" = {
    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        "$mod" = "SUPER";
        "$terminal" = "kitty";

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
        };

        decoration.rounding = 8;

        input = {
          kb_layout = "us";
          follow_mouse = 1;
        };

        # Usable session binds (terminal, focus, workspaces).
        bind = [
          "$mod, T, exec, $terminal"
          "$mod, C, killactive,"
          "$mod, M, exit,"
          "$mod, F, fullscreen,"
          "$mod SHIFT, F, togglefloating,"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
