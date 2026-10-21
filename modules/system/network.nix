# NetworkManager + firewall + systemd-resolved.
# Opportunistic DoT and allow-downgrade DNSSEC; Domains = ["~."] sends all
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
      settings.Resolve = {
        DNSSEC = "allow-downgrade";
        DNSOverTLS = "opportunistic";
        Domains = [ "~." ];
        FallbackDNS = [
          "1.1.1.1"
          "9.9.9.9"
        ];
      };
    };
  };
}
