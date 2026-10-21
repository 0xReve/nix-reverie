# OBS Studio for Hyprland/NVIDIA hosts.
#
# Screencast needs xdg-desktop-portal-hyprland (hyprland aspect) and a normal
# session launch.
{
  flake.modules.nixos.obs =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;

        # NVENC (RTX). Without this, obs-nvenc fails with nvenc_lib.
        package = pkgs.obs-studio.override {
          cudaSupport = true;
        };

        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          obs-vkcapture
        ];
      };
    };
}
