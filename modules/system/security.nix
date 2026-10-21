# Baseline hardenings: restrict kernel info leaks, sudo for wheel only with a
# short timestamp, and fail2ban on exposed services.
{
  flake.modules.nixos.security = {
    security.protectKernelImage = true;
    boot.kernel.sysctl = {
      "kernel.unprivileged_bpf_disabled" = 1;
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
    };
    security.sudo = {
      enable = true;
      wheelNeedsPassword = true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults passwd_tries=3
        Defaults timestamp_timeout=15
      '';
    };
    services.fail2ban.enable = true;
  };
}
