# Obsidian notes for reve.
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.obsidian ];
    };
}
