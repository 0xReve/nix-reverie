# Nix LSP for reve (Cursor nix-ide / editor tooling).
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nil ];
    };
}
