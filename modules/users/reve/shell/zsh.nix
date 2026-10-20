# Interactive zsh for reve (login shell is already pkgs.zsh on the account).
# Dual oh-my-posh: omp-tty on TERM=linux, omp-custom elsewhere.
# enableZshIntegration left false so the TTY gate stays authoritative.
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

        initContent = ''
          if [[ "$TERM" == "linux" ]]; then
            eval "$(oh-my-posh init zsh --config ${./omp-tty.omp.json})"
          else
            eval "$(oh-my-posh init zsh --config ${./omp-custom.omp.json})"
          fi
        '';
      };

      programs.oh-my-posh = {
        enable = true;
        enableZshIntegration = false;
      };
    };
}
