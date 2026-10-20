# EasyEffects presets for reve.
# Ambxst owns the daemon and remembers last-loaded presets; ship JSON only.
{
  flake.modules.homeManager."users/reve" = {
    xdg.dataFile."easyeffects/input/desk-mic.json" = {
      force = true;
      source = ./easyeffects/desk-mic.json;
    };

    xdg.dataFile."easyeffects/output/sundara.json" = {
      force = true;
      source = ./easyeffects/sundara.json;
    };
  };
}
