# linux-zen for desk hosts (26.05 ships 7.2.x; no unstable pin needed).
{
  flake.modules.nixos.kernel-zen =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_zen;
    };
}
