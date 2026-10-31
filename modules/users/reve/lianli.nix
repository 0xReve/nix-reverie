# Lian Li user daemon config seed + stable unit link for reve.
# Seeds ~/.config/lianli/config.json once (fans/RGB/pump; no AIO LCD media).
# GUI may rewrite that file afterward.
{
  flake.modules.homeManager."users/reve" =
    { lib, ... }:
    let
      seed = ./lianli-config.json;
      unit = "/etc/static/systemd/user/lianli-daemon.service";
    in
    {
      home.activation.lianliConfigSeed = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        conf="$HOME/.config/lianli/config.json"
        mkdir -p "$(dirname "$conf")"
        if [ ! -e "$conf" ]; then
          cp ${seed} "$conf"
          chmod u+w "$conf"
        fi
      '';

      # Keep the enable symlink on /etc/static so GC cannot orphan a store path.
      home.activation.lianliDaemonUnit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        unit_dir="$HOME/.config/systemd/user"
        mkdir -p "$unit_dir/default.target.wants"
        ln -sfn ${lib.escapeShellArg unit} "$unit_dir/lianli-daemon.service"
        ln -sfn ${lib.escapeShellArg unit} "$unit_dir/default.target.wants/lianli-daemon.service"
      '';
    };
}
