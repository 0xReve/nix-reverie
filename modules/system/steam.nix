# Steam + Proton-GE. Pair with graphics (and nvidia on desk GPUs).
{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        # Clear IME env for Steam only (ibus/XMODIFIERS break overlay text input).
        package = pkgs.steam.override {
          extraEnv = {
            GTK_IM_MODULE = "";
            QT_IM_MODULE = "";
            SDL_IM_MODULE = "";
            XMODIFIERS = "";
            GLFW_IM_MODULE = "";
          };
        };
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };
    };
}
