# WayVR desktop overlay for SteamVR / OpenXR. Pair with steam (and
# bigscreen-beyond on lighthouse hosts). Hyprland portal covers screencast.
{
  flake.modules.nixos.wayvr =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.wayvr ];

      # SteamVR's OpenVR runtime lives in Steam's FHS tree. Native WayVR
      # cannot attach without steam-run (NixOS VR wiki). Prefer --wait over
      # SteamVR manifest autostart (upstream marks that path unreliable).
      systemd.user.services.wayvr = {
        description = "WayVR desktop overlay (OpenVR via steam-run)";
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.steam-run} ${lib.getExe pkgs.wayvr} --openvr --wait --replace";
          Restart = "on-failure";
          RestartSec = "3";
        };
      };
    };
}
