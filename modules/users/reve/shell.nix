# Interactive zsh for reve (login shell is already pkgs.zsh on the account).
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

      programs.zsh = {
        enable = true;
        # Avoid nix-zsh-completions _nixos-rebuild clash on nixos-25.11.
        enableCompletion = false;
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
