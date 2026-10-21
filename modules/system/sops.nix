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
          # Host key only: neededForUsers runs before /home is mounted.
          # A missing keyFile aborts decrypt even when the host key works.
          # Edit secrets with SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt.
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };
        gnupg.sshKeyPaths = [ ];
      };
    };
}
