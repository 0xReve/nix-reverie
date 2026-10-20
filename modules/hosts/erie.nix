# Desk workstation leaf. Grow the import list as aspects land.
{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.modules.nixos."hosts/erie" = {
    imports = [
      nixos.base
      nixos.locale
      nixos.nixpkgs
      nixos.home-manager
      nixos.network
      nixos.tools
      nixos."hardware/erie"
      nixos."users/reve"
    ];

    networking.hostName = "erie";
    system.stateVersion = "25.11";
  };
}
