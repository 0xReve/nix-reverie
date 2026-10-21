# Kitty terminal for reve (HM, not systemPackages).
{
  flake.modules.homeManager."users/reve" =
    { config, pkgs, ... }:
    {
      home.sessionVariables.TERMINAL = "${pkgs.kitty}/bin/kitty";

      # Preferred terminal for xdg-terminal-exec (Ambxst TUI launches, etc.).
      xdg.configFile."xdg-terminals.list".text = ''
        kitty.desktop
      '';

      programs.kitty = {
        enable = true;
        extraConfig = ''
          confirm_os_window_close 0
          # Default remember_window_size restores maximized from
          # ~/.cache/kitty/main.json and Hyprland treats that as fullscreen.
          remember_window_size no
          # Ambxst KittyGenerator writes this from the active palette and
          # reloads kitty with SIGUSR1 on theme change.
          include ${config.home.homeDirectory}/.cache/ambxst/kitty.conf
        '';
      };
    };
}
