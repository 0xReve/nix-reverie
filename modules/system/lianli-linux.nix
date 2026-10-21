# Lian Li HydroShift / UNI FAN via lian-li-linux (upstream v1.2.2).
# User daemon + udev; EVDI / virtual display stays off.
{
  flake.modules.nixos.lianli-linux =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.lianli-linux ];

      # Grants the active seat non-root access to hidraw/usb nodes.
      services.udev.packages = [ pkgs.lianli-linux ];

      # Upstream 1.2+ refuses to start without these flock files in /run.
      systemd.tmpfiles.packages = [ pkgs.lianli-linux ];

      # Upstream udev rules assign GROUP=lianli (MODE 0660).
      users.groups.lianli = { };
      users.users.reve.extraGroups = [ "lianli" ];

      # Per-user daemon (GUI talks over a socket in $XDG_RUNTIME_DIR).
      systemd.user.services.lianli-daemon = {
        description = "Lian Li Device Daemon";
        wantedBy = [ "default.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.lianli-linux}/bin/lianli-daemon";
          Restart = "on-failure";
          RestartSec = 5;
          # Fan-curve sensors shell out to nvidia-smi / awk; default user PATH
          # is too thin.
          Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin";
        };
      };
    };
}
