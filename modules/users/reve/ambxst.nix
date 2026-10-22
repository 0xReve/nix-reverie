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
      # PowerMenu: hyprctl exit (axctl Lua dispatch is broken on this Hyprland)
      # and /bin/sh for Process (NixOS has no /bin/bash by default).
      powermenuNixosShMod = ./ambxst-mods/powermenu-nixos-sh;
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

      # Keep the PowerMenu logout mod installed at the flake version.
      home.activation.ambxstPowermenuNixosSh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH="/run/current-system/sw/bin:$PATH"
        if ! command -v ambxst >/dev/null 2>&1; then
          exit 0
        fi
        mod_src="${powermenuNixosShMod}"
        mod_id="local.powermenu-nixos-sh"
        want_ver="1.1.0"
        have_ver="$(ambxst mods list 2>/dev/null | awk -v id="$mod_id" '$2 == id { print $3; exit }')"
        if [ "$have_ver" != "$want_ver" ]; then
          ambxst mods remove "$mod_id" 2>/dev/null || true
          ambxst mods install "$mod_src" || true
        fi
        if ambxst mods list 2>/dev/null | grep -q "disabled[[:space:]]\+$mod_id"; then
          ambxst mods enable "$mod_id" || true
        elif ! ambxst mods list 2>/dev/null | grep -q "$mod_id"; then
          ambxst mods install "$mod_src" || true
          ambxst mods enable "$mod_id" || true
        fi
      '';

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

      # GTK: adw-gtk3 + settings. Leave color-scheme and gtk.css to Ambxst
      # (GtkGenerator writes css; axctl darkmode flips prefer-light/dark).
      gtk = {
        enable = true;
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
