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
      nixos.mt7927
      nixos.tools
      nixos.ssh
      nixos.security
      nixos.sops
      nixos.kernel-zen
      nixos.graphics
      nixos.nvidia
      nixos.lianli-linux
      nixos.openrazer
      nixos.steam
      nixos.gaming
      nixos.obs
      nixos.mangohud
      nixos.bigscreen-beyond
      nixos.greeter
      nixos.hyprland
      nixos.hyprland-nvidia
      nixos.audio
      nixos.bluetooth
      nixos.ambxst
      nixos."hardware/erie"
      nixos."users/reve"
    ];

    networking.hostName = "erie";
    system.stateVersion = "25.11";
  };
}
