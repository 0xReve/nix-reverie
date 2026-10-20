# Kitty terminal for reve (HM, not systemPackages).
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.sessionVariables.TERMINAL = "${pkgs.kitty}/bin/kitty";

      programs.kitty = {
        enable = true;
        extraConfig = ''
          confirm_os_window_close 0
        '';
      };
    };
}
