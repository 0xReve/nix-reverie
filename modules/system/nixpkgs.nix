# Unfree policy as an opt-in aspect (visible in each host import list).
{
  flake.modules.nixos.nixpkgs = {
    nixpkgs.config.allowUnfree = true;
  };
}
