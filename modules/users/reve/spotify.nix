# Spiced Spotify (spicetify-nix) for reve.
{ inputs, ... }:
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
        enabledExtensions = with spicePkgs.extensions; [
          beautifulLyrics
        ];
      };
    };
}
