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
          keyFile = "/home/reve/.config/sops/age/keys.txt";
          sshKeyPaths = [ ];
        };
        gnupg.sshKeyPaths = [ ];
      };
    };
}
