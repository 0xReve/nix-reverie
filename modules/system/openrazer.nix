# OpenRazer daemon + Polychromatic for desk Razer gear (erie).
# users = [ "reve" ] is required for plugdev/openrazer group membership.
{
  flake.modules.nixos.openrazer =
    { pkgs, ... }:
    {
      hardware.openrazer.enable = true;
      hardware.openrazer.users = [ "reve" ];

      environment.systemPackages = with pkgs; [
        polychromatic
      ];
    };
}
