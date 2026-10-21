# MangoHud overlay for gaming hosts.
{
  flake.modules.nixos.mangohud =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.mangohud ];
    };
}
