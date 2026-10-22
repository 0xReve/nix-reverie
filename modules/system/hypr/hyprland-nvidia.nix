# Hyprland session env for NVIDIA hosts. Pair with graphics + nvidia + hyprland.
{
  flake.modules.nixos.hyprland-nvidia = {
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      # Electron/CEF: nixpkgs wrappers (Equibop, Obsidian, …) and Hyprland Ozone hint.
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };
}
