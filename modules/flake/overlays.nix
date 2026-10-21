# Host + perSystem package set extensions.
{ inputs, ... }:
{
  flake.overlays.default = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };

    # Upstream needs rustc ≥1.98; build on unstable.
    lianli-linux = final.unstable.callPackage ../../pkgs/lianli-linux/package.nix { };
  };
}
