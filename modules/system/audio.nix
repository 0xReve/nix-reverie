# PipeWire + rtkit baseline. Host device defaults stay in a later host aspect.
{
  flake.modules.nixos.audio =
    { pkgs, ... }:
    {
      security.rtkit.enable = true;
      programs.dconf.enable = true;
      services.pulseaudio.enable = false;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };

      environment.systemPackages = with pkgs; [
        crosspipe
        pavucontrol
        pamixer
        pipewire
        pulseaudio
        wireplumber
      ];
    };
}
