# Proprietary NVIDIA driver for discrete GPUs (desk, no PRIME).
# Requires flake.modules.nixos.graphics and nixpkgs (allowUnfree) on the host.
# New-feature 615.78.08 on linux-zen 7.2 (Minecraft Iris OpenGL / SDL).
{
  flake.modules.nixos.nvidia =
    { config, ... }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        # Save/restore VRAM across suspend so Hyprland comes back with a picture.
        powerManagement.enable = true;
        # Driver 560+ requires an explicit open/proprietary choice.
        # Proprietary matches the last known-good desk setup on this channel.
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "615.78.08";
          sha256_64bit = "sha256-Pj9t3cLudnoIGFMAr3vjyyhuznZpjS3eNSRZl4LQf/4=";
          sha256_aarch64 = "sha256-UHYBE1AYHoGgMfD9AS/jX+S+N8eCDWUft6qolK9Eejc=";
          openSha256 = "sha256-HBINiOjL0ZJLIAJeNIBYHBnwgUXtNwPPtnFpAI1YwF4=";
          settingsSha256 = "sha256-inDRpG02sdDgHmlqgu/DsgK8OFdOt1fZIYyXdhlGC/c=";
          persistencedSha256 = "sha256-RzeR6Ldct6MUxjnXRyThdh5Y3jjMehTVg85MtwuWNX4=";
        };
      };
    };
}
