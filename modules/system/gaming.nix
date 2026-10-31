# GameMode + Gamescope + Proton host limits. Pair with steam on gaming hosts.
{
  flake.modules.nixos.gaming = {
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    # Wine/Proton: large avatar/world loads need high map and fd ceilings.
    # Split-lock mitigation can stutter Steam UI and some Proton titles.
    boot.kernel.sysctl = {
      "vm.max_map_count" = 1048576;
      "kernel.split_lock_mitigate" = 0;
    };
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "1048576";
      }
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "1048576";
      }
    ];
  };
}
