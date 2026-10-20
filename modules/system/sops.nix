# Secrets via sops-nix (age).
{ inputs, ... }:
{
  flake.modules.nixos.sops =
    { pkgs, config, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      environment.systemPackages = with pkgs; [
        sops
        age
        ssh-to-age
      ];

      sops = {
        defaultSopsFile = "${inputs.nix-secrets}/sops/${config.networking.hostName}.yaml";
        defaultSopsFormat = "yaml";
        validateSopsFiles = false;
        age = {
          # Host ed25519 key (via ssh). Keep the age file until nix-secrets
          # lists that host recipient and secrets are re-encrypted.
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = "/home/reve/.config/sops/age/keys.txt";
        };
        gnupg.sshKeyPaths = [ ];
      };
    };
}
