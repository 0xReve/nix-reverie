# Cursor editor for reve via omarcresp/cursor-flake (auto-updated).
{ inputs, ... }:
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.cursor.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
