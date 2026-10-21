# Proprietary NVIDIA driver for discrete GPUs (desk, no PRIME).
# Requires flake.modules.nixos.graphics and nixpkgs (allowUnfree) on the host.
# 595.71.05 (channel stable) does not build against linux 7.2; pin 595.99.02.
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
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "595.99.02";
          sha256_64bit = "sha256-6HR3lYv3YwcFSTJL1a1slI66btIQ5EAFs+/4SUD24ew=";
          sha256_aarch64 = "sha256-CCqHZTN2KNOZ4yZp2rDcuRJp9pHfRw47k4m4dWnS/2w=";
          openSha256 = "sha256-T36x/jx8yQ8l3LFp1rZIrTfcSwbGy8YSAvXOUSptpb4=";
          settingsSha256 = "sha256-GYCcnxfKPrTCrsmd25sMyzfC5cqJQJx0c31haooyTYM=";
          persistencedSha256 = "sha256-VyKtF/HdHPQrHHK6opSO69M72LmnGZtauuchj9uuje8=";
        };
      };
    };
}
