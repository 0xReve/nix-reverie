# Equibop (Equicord) via nixcord for reve.
{ inputs, ... }:
{
  flake.modules.homeManager."users/reve" = {
    imports = [ inputs.nixcord.homeModules.nixcord ];

    programs.nixcord = {
      enable = true;
      discord.enable = false;
      equibop.enable = true;

      config = {
        themeLinks = [
          # Dark (mocha blue).
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha-blue.theme.css"
          # Light (latte blue).
          "https://catppuccin.github.io/discord/dist/catppuccin-latte-blue.theme.css"
        ];
        enabledThemeLinks = [
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha-blue.theme.css"
          "https://catppuccin.github.io/discord/dist/catppuccin-latte-blue.theme.css"
        ];
      };
    };
  };
}
