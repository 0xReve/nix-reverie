# Hyprland Wayland session (system). User conf lands in HM later.
{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      security.polkit.enable = true;

      services.gvfs.enable = true;
      services.udisks2.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
          pkgs.xdg-desktop-portal-gtk
        ];
      };

      environment.systemPackages = with pkgs; [
        hyprpaper
        wl-clipboard
        xdg-utils
      ];
    };
}
