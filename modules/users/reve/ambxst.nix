# Ambxst for reve: autostart, Hypr sources Ambxst-generated binds/appearance.
{
  flake.modules.homeManager."users/reve" =
    { lib, ... }:
    {
      # Stub so Hypr can source before the first Ambxst run writes the real file.
      # Writable path (not an HM symlink) so axctl can rewrite it later.
      home.activation.ambxstHyprStub = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/.local/share/ambxst"
        if [ ! -e "$HOME/.local/share/ambxst/hyprland.conf" ]; then
          touch "$HOME/.local/share/ambxst/hyprland.conf"
        fi
      '';

      wayland.windowManager.hyprland = {
        # Ambxst owns binds, gaps, and appearance via the generated share file.
        # Keep a single exec-once so the shell starts even when that file is empty.
        settings.exec-once = [ "ambxst" ];

        extraConfig = ''
          # Ambxst (binds / appearance). Overrides below if needed.
          source = ~/.local/share/ambxst/hyprland.conf
        '';
      };
    };
}
