# CLI toolkit for reve (wired with zsh aliases / integrations).
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        eza
        fd
        ripgrep
        tealdeer
        bat-extras.batdiff
        bat-extras.batgrep
        bat-extras.batman
        bat-extras.batpipe
        bat-extras.prettybat
        lazygit
        fastfetch
      ];

      programs.bat = {
        enable = true;
        config = {
          style = "numbers,changes,header";
          pager = "less -FR";
        };
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultOptions = [
          "--height 40%"
          "--layout=reverse"
          "--border"
        ];
      };

      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.pay-respects = {
        enable = true;
        enableZshIntegration = true;
        options = [
          "--alias"
          "fuck"
        ];
      };

      programs.zsh = {
        shellAliases = {
          c = "clear";
          cp = "cp -iv";
          md = "mkdir -p";
          mv = "mv -iv";
          rd = "rmdir";
          rm = "rm -iv";
          please = "sudo $(fc -ln -1)";
          ".." = "cd ..";
          "..." = "cd ../..";
          cat = "bat --paging=never --style=plain";
          man = "batman";
          find = "fd";
          grep = "rg";
        };

        # eza: skip Nerd icons on the Linux console (TERM=linux).
        initContent = ''
          if [[ "$TERM" == "linux" ]]; then
            alias l='eza -lah --group-directories-first --git'
            alias lt='eza --tree --group-directories-first -L 2'
          else
            alias l='eza -lah --icons --group-directories-first --git'
            alias lt='eza --tree --icons --group-directories-first -L 2'
          fi
        '';
      };
    };
}
