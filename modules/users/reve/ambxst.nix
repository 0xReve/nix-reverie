# Ambxst for reve: autostart, Hypr sources, and theme consumers.
{
  flake.modules.homeManager."users/reve" =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      home = config.home.homeDirectory;
      qtAppearance = {
        color_scheme_path = "${home}/.config/qt5ct/colors/ambxst.colors";
        custom_palette = true;
        standard_dialogs = "default";
        style = "Fusion";
      };
      qt6Appearance = qtAppearance // {
        color_scheme_path = "${home}/.config/qt6ct/colors/ambxst.colors";
      };
    in
    {
      # Stub so Hypr can source before the first Ambxst run writes the real file.
      # Writable path (not an HM symlink) so axctl can rewrite it later.
      home.activation.ambxstHyprStub = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/.local/share/ambxst"
        if [ ! -e "$HOME/.local/share/ambxst/hyprland.conf" ]; then
          touch "$HOME/.local/share/ambxst/hyprland.conf"
        fi
      '';

      # Ambxst DiscordGenerator writes vesktop only; equibop needs the same CSS.
      home.file.".config/equibop/themes/ambxst.css".source =
        config.lib.file.mkOutOfStoreSymlink "${home}/.config/vesktop/themes/ambxst.css";

      # PywalZenGenerator writes ~/.cache/ambxst/pywalzen.css; Zen must import it.
      home.activation.ambxstZenChrome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        import_line='@import url("file://${home}/.cache/ambxst/pywalzen.css");'
        for chrome in "$HOME"/.zen/*/chrome; do
          [ -d "$chrome" ] || continue
          uc="$chrome/userChrome.css"
          if [ -f "$uc" ]; then
            if ! grep -qF 'ambxst/pywalzen.css' "$uc"; then
              tmp="$uc.ambxst.tmp"
              printf '%s\n\n' "$import_line" > "$tmp"
              cat "$uc" >> "$tmp"
              mv "$tmp" "$uc"
            fi
          else
            printf '%s\n' "$import_line" > "$uc"
          fi
        done
      '';

      # GTK: adw-gtk3 + settings/dconf. Leave gtk.css to GtkGenerator (writable).
      gtk = {
        enable = true;
        colorScheme = "dark";
        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
        # stateVersion < 26.05 would inherit gtk.theme into gtk4 and overwrite
        # Ambxst gtk.css; keep gtk4 theme unset so only settings.ini is managed.
        gtk4.theme = null;
      };

      # Qt: qt5ct/qt6ct with Ambxst color schemes (QtCtGenerator).
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        qt5ctSettings.Appearance = qtAppearance;
        qt6ctSettings.Appearance = qt6Appearance;
      };

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
