# Stock Ambxst (Quickshell shell + lock). Package and fonts from upstream module.
{ inputs, ... }:
{
  flake.modules.nixos.ambxst = { pkgs, ... }: {
    imports = [ inputs.ambxst.nixosModules.default ];
    # Ambxst ships GSR 6.x; stable wrapper must match for setuid kms server.
    programs.gpu-screen-recorder.package = pkgs.unstable.gpu-screen-recorder;
  };
}
