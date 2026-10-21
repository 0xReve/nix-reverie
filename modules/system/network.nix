# NetworkManager + firewall + systemd-resolved.
# Opportunistic DoT and allow-downgrade DNSSEC; domains = ["~."] sends all
# lookups through resolved.
{
  flake.modules.nixos.network = {
    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };
      firewall = {
        enable = true;
        logRefusedPackets = true;
      };
    };

    services.resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      dnsovertls = "opportunistic";
      domains = [ "~." ];
      fallbackDns = [
        "1.1.1.1"
        "9.9.9.9"
      ];
    };
  };
}
