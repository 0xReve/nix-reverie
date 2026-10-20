# Zen Browser for reve (default http(s) handler).
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
