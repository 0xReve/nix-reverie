# flake-parts' flakeModules.modules sets _class/_file via apply but not `key`.
# Without a stable key, an aspect imported via two paths is applied twice.
# Own the option here instead of importing flakeModules.modules.
# See: https://github.com/hercules-ci/flake-parts/issues/251
{ lib, moduleLocation, ... }:
let
  inherit (lib) mapAttrs mkOption types;
  inherit (lib.strings) escapeNixIdentifier;

  addInfo =
    class: moduleName:
    if class == "generic" then
      module: module
    else
      module:
      { ... }:
      {
        key = "flake.modules.${class}.${moduleName}";
        _class = class;
        _file = "${toString moduleLocation}#modules.${escapeNixIdentifier class}.${escapeNixIdentifier moduleName}";
        imports = [ module ];
      };
in
{
  options.flake.modules = mkOption {
    type = types.lazyAttrsOf (types.lazyAttrsOf types.deferredModule);
    description = ''
      Groups of modules published by the flake (nixos / homeManager / …),
      with stable `key` so dual imports do not double-apply.
    '';
    apply = mapAttrs (k: mapAttrs (addInfo k));
  };
}
