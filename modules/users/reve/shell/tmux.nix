# tmux for reve. Ambxst ships tmux and owns session UI (Super+T); this is config only.
{
  flake.modules.homeManager."users/reve" =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        terminal = "screen-256color";
        clock24 = true;
        mouse = true;
        historyLimit = 100000;
        extraConfig = ''
          set -g set-titles off
          set -g allow-rename off
          set -g automatic-rename off
        '';
        plugins = with pkgs.tmuxPlugins; [
          {
            plugin = catppuccin;
            extraConfig = ''
              set -g @catppuccin_flavour "mocha"
              set -g status-left ""
              set -g status-right ""
            '';
          }
        ];
      };
    };
}
