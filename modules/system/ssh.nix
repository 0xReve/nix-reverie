# OpenSSH: host keys for sops-nix age. Daemon on, port not opened in the firewall.
{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
