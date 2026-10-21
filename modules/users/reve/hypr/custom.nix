# Hypr input overrides from nix-secrets.
{ inputs, ... }:
{
  flake.modules.homeManager."users/reve" = {
    imports = [ "${inputs.nix-secrets}/hypr/custom.nix" ];
  };
}
