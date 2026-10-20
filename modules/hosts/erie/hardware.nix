# Host hardware; machine details come from nix-secrets.
{ inputs, ... }:
{
  flake.modules.nixos."hardware/erie" = {
    imports = [
      # Imported here (not from hardware-config) to avoid modulesPath recursion
      # under flake.modules key wrapping.
      "${inputs.nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
      (import "${inputs.nix-secrets}/hosts/erie/profiles.nix" { inherit inputs; })
      "${inputs.nix-secrets}/hosts/erie/hardware-config.nix"
    ];
  };
}
