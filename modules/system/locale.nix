# Timezone and default locale.
{
  flake.modules.nixos.locale = {
    time.timeZone = "UTC";
    i18n.defaultLocale = "en_US.UTF-8";
  };
}
