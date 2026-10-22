# SteamVR-first Bigscreen Beyond. Steam already ships Valve/Vive lighthouse
# udev via programs.steam → hardware.steam-hardware; this fills Bigscreen
# hidraw, headset audio profiles, and the NixOS SteamVR setcap/pkexec hole.
{
  flake.modules.nixos.bigscreen-beyond =
    { lib, pkgs, ... }:
    let
      vrCompositorLauncher = "/home/reve/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";

      # SteamVR asks pkexec to setcap from inside bwrap. Host CAP_SYS_NICE
      # silences that prompt. Async reprojection still cannot use the cap
      # inside Steam's user namespace on NixOS (nixpkgs#217119).
      steamvrSetcap = pkgs.writeShellScript "steamvr-cap-sys-nice" ''
        set -eu
        bin=${lib.escapeShellArg vrCompositorLauncher}
        if [ -x "$bin" ]; then
          ${lib.getExe' pkgs.libcap "setcap"} CAP_SYS_NICE=eip "$bin"
        fi
      '';
    in
    {
      # Hide Adaptive Sync / VRR caps from NVIDIA modeset. Desktop VRR still
      # leaks into SteamVR presents as a moving tear/latency split in the HMD.
      boot.kernelParams = [ "nvidia-modeset.conceal_vrr_caps=1" ];

      environment.systemPackages = [ pkgs.lighthouse-steamvr ];

      # Playback = Strap (0105); mic = Beyond HMD (0101). Inactive ACP profiles
      # leave PipeWire with no sink/source and silent SteamVR audio. Sticky
      # mute on the HMD capture node also silences the mic across sessions.
      services.pipewire.wireplumber.extraConfig."51-bigscreen-beyond" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "device.name" = "~alsa_card.usb-Bigscreen_Beyond_Audio_Strap.*"; }
            ];
            actions = {
              update-props = {
                "device.profile" = "output:analog-stereo";
              };
            };
          }
          {
            matches = [
              {
                "device.name" = "~alsa_card.usb-Bigscreen_Beyond_.*";
                "device.product.id" = "0x0101";
              }
            ];
            actions = {
              update-props = {
                "device.profile" = "input:analog-stereo";
              };
            };
          }
          {
            matches = [
              { "node.name" = "~alsa_input.usb-Bigscreen_Beyond_.*"; }
            ];
            actions = {
              update-props = {
                "node.mute" = false;
                # Below typical USB sinks (~1100) so Komplete stays desk default.
                "priority.session" = 500;
              };
            };
          }
          {
            matches = [
              { "node.name" = "~alsa_output.usb-Bigscreen_Beyond_Audio_Strap.*"; }
            ];
            actions = {
              update-props = {
                "priority.session" = 500;
              };
            };
          }
        ];
        "device.profile.priority.rules" = [
          {
            matches = [
              { "device.name" = "~alsa_card.usb-Bigscreen_Beyond_Audio_Strap.*"; }
            ];
            actions = {
              update-props = {
                priorities = [ "output:analog-stereo" ];
              };
            };
          }
          {
            matches = [
              {
                "device.name" = "~alsa_card.usb-Bigscreen_Beyond_.*";
                "device.product.id" = "0x0101";
              }
            ];
            actions = {
              update-props = {
                priorities = [ "input:analog-stereo" ];
              };
            };
          }
        ];
      };

      services.udev.extraRules = ''
        # Bigscreen Beyond (LVRA hidraw; uaccess for the active seat)
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0101", MODE="0660", TAG+="uaccess"
        # Bigscreen Beyond Firmware Mode
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="4004", MODE="0660", TAG+="uaccess"
        # Bigscreen Beyond Error Mode
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="1001", MODE="0660", TAG+="uaccess"

        # Bigscreen Bigeye
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", TAG+="uaccess"
        # Bigscreen Bigeye DFU Mode
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0282", MODE="0660", TAG+="uaccess"
      '';

      systemd.services.steamvr-cap-sys-nice = {
        description = "Set CAP_SYS_NICE on SteamVR vrcompositor-launcher";
        wantedBy = [ "multi-user.target" ];
        after = [ "local-fs.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = steamvrSetcap;
        };
      };

      # Re-apply after SteamVR updates replace the binary.
      systemd.paths.steamvr-cap-sys-nice = {
        wantedBy = [ "multi-user.target" ];
        pathConfig = {
          PathExists = vrCompositorLauncher;
          PathChanged = vrCompositorLauncher;
        };
      };
    };
}
