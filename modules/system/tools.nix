# Day-to-day flake tooling on the system (not only nix develop).
{
  flake.modules.nixos.tools =
    { pkgs, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 3";
        };
      };

      environment.systemPackages = with pkgs; [
        nixfmt
        deadnix
        statix
      ];
    };
}
