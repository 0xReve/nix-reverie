# BlueZ + blueman.
{
  flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        # LE battery reports and modern GATT features.
        settings.General.Experimental = true;
      };

      services.blueman.enable = true;

      environment.systemPackages = with pkgs; [
        blueman
        bluez
        bluez-tools
      ];
    };
}
