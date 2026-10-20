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
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
        };
      };
    };
}
