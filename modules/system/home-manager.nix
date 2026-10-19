# Home Manager as a NixOS module.
{ inputs, ... }:
{
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupCommand = "cp -p --preserve=mode,ownership,timestamps {src} {dst}.$(date +%Y%m%d-%H%M%S)";
  };
}
