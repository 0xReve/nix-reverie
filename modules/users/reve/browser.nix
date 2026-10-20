# Zen Browser for reve (BROWSER + default http(s) mime via setAsDefaultBrowser).
{ inputs, ... }:
{
  flake.modules.homeManager."users/reve" = {
    imports = [ inputs.zen-browser.homeModules.twilight ];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };

    home.sessionVariables.BROWSER = "zen-twilight";
  };
}
