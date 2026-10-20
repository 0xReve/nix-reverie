# Proprietary NVIDIA driver for discrete GPUs (desk, no PRIME).
# Requires flake.modules.nixos.graphics and nixpkgs (allowUnfree) on the host.
{
  flake.modules.nixos.nvidia =
    { config, ... }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        # Driver 560+ requires an explicit open/proprietary choice.
        # Proprietary matches the last known-good desk setup on this channel.
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };
}
