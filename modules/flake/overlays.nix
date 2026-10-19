# Host + perSystem package set extensions.
{ inputs, ... }:
{
  flake.overlays.default = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };
}
