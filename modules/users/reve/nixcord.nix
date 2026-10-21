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
        # Ambxst DiscordGenerator writes ambxst.css (symlinked into equibop/themes).
        enabledThemes = [ "ambxst.css" ];
      };
    };
  };
}
