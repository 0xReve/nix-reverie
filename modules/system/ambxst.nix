# Stock Ambxst (Quickshell shell + lock). Package and fonts from upstream module.
{ inputs, ... }:
{
  flake.modules.nixos.ambxst = {
    imports = [ inputs.ambxst.nixosModules.default ];
  };
}
