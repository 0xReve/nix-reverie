# Equibop (Equicord) via nixcord for reve.
{ inputs, ... }:
{
  flake.modules.homeManager."users/reve" =
    { lib, config, ... }:
    {
      imports = [ inputs.nixcord.homeModules.nixcord ];

      programs.nixcord = {
        enable = true;
        discord.enable = false;
        equibop.enable = true;
      };

      # nixcord would otherwise symlink Equicord settings from the store.
      home.file."${config.xdg.configHome}/equibop/settings/settings.json".enable = lib.mkForce false;
    };
}
