# Turn flake.modules.nixos."hosts/*" into flake.nixosConfigurations.
{
  inputs,
  config,
  self,
  ...
}:
let
  prefix = "hosts/";
  npLib = inputs.nixpkgs.lib;
in
{
  flake.nixosConfigurations = npLib.mapAttrs' (
    name: module:
    npLib.nameValuePair (npLib.removePrefix prefix name) (
      npLib.nixosSystem {
        modules = [
          {
            nixpkgs.hostPlatform = npLib.mkDefault "x86_64-linux";
            nixpkgs.overlays = [ self.overlays.default ];
          }
          module
        ];
      }
    )
  ) (npLib.filterAttrs (name: _: npLib.hasPrefix prefix name) config.flake.modules.nixos);
}
