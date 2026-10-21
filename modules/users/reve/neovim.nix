# LazyVim-wrapped nvim for reve (EDITOR / VISUAL / GIT_EDITOR).
{ inputs, ... }:
{
  flake.modules.homeManager."users/reve" =
    { pkgs, lib, ... }:
    let
      lazyVim = inputs.lazy-nvim-nix.packages.${pkgs.stdenv.hostPlatform.system}.LazyVim;
      nvimWithDeps = pkgs.runCommand "nvim-lazyvim" { buildInputs = [ pkgs.makeWrapper ]; } ''
        makeWrapper ${lazyVim}/bin/nvim $out/bin/nvim \
          --prefix PATH : ${
            lib.makeBinPath [
              pkgs.fd
              pkgs.ripgrep
              pkgs.bat
              pkgs.wl-clipboard
              pkgs.lazygit
            ]
          }
        ln -s ${lazyVim}/share $out/share
      '';
    in
    {
      home.packages = [ nvimWithDeps ];

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        GIT_EDITOR = "nvim";
      };
    };
}
