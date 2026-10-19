# Minimal host baseline imported by every machine.
{
  flake.modules.nixos.base =
    { lib, pkgs, ... }:
    {
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = false;
      };
      programs.git.enable = true;

      boot.loader.systemd-boot.enable = lib.mkDefault true;
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

      fileSystems."/" = lib.mkDefault {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };

      environment.systemPackages = with pkgs; [
        curl
        wget
      ];
    };
}
