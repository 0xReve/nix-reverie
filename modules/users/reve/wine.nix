# Wine + winetricks for reve (wow64 = 32- and 64-bit prefixes).
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.wineWow64Packages.stable
        pkgs.winetricks
      ];
    };
}
