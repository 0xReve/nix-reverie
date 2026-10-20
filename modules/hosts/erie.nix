# Desk workstation leaf. Grow the import list as aspects land.
{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.modules.nixos."hosts/erie" = {
    imports = [
      nixos.base
      nixos.locale
      "${inputs.nix-secrets}/locale.nix"
      nixos.nixpkgs
      nixos.home-manager
      nixos.network
      nixos.tools
      nixos.sops
      nixos.graphics
      nixos.nvidia
      nixos.greeter
      nixos.hyprland
      nixos.hyprland-nvidia
      nixos.audio
      nixos."hardware/erie"
      nixos."users/reve"
    ];

    networking.hostName = "erie";
    system.stateVersion = "25.11";
  };
}
