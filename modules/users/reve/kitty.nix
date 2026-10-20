# Kitty terminal for reve (HM, not systemPackages).
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
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
        '';
      };
    };
}
