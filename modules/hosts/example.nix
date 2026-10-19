# Placeholder host so the boilerplate flake evaluates.
# Rename / replace when adding a real machine.
{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.modules.nixos."hosts/example" = {
    imports = [
      nixos.base
      nixos.nixpkgs
      nixos.home-manager
      nixos.tools
      nixos."users/example"
    ];

    networking.hostName = "example";
    system.stateVersion = "25.11";
  };
}
