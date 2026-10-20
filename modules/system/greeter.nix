# greetd + tuigreet. No initial_session / autologin.
{
  flake.modules.nixos.greeter =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      sessionData = config.services.displayManager.sessionData.desktops;
    in
    {
      services.displayManager.sddm.enable = lib.mkForce false;
      services.displayManager.gdm.enable = lib.mkForce false;

      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings = {
          default_session = {
            command = ''
              ${pkgs.tuigreet}/bin/tuigreet \
                --sessions ${sessionData}/share/wayland-sessions \
                --xsessions ${sessionData}/share/xsessions \
                --remember --remember-user-session \
                --user-menu --asterisks
            '';
            user = "greeter";
          };
        };
      };

      # tuigreet --remember needs a writable cache.
      systemd.tmpfiles.rules = [
        "d '/var/cache/tuigreet' - greeter greeter - -"
      ];
    };
}
