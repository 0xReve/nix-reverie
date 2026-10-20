# Desk workstation leaf. Grow the import list as aspects land.
{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.modules.nixos."hosts/erie" = {
    imports = [
      nixos.base
      nixos.nixpkgs
      nixos.home-manager
      nixos.tools
      nixos."hardware/erie"
      nixos."users/reve"
    ];

    networking.hostName = "erie";
    system.stateVersion = "25.11";
  };
}
