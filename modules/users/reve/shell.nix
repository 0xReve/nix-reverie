# Interactive zsh for reve (login shell is already pkgs.zsh on the account).
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        history = {
          size = 10000;
          save = 10000;
          share = true;
          ignoreDups = true;
          ignoreSpace = true;
        };
      };
    };
}
