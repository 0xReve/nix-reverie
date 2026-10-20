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
        # Built against sops-nix's own nixpkgs (not 25.11) so Go matches upstream.
        package = inputs.sops-nix.packages.${pkgs.stdenv.hostPlatform.system}.sops-install-secrets;
        age = {
          keyFile = "/home/reve/.config/sops/age/keys.txt";
          sshKeyPaths = [ ];
        };
        gnupg.sshKeyPaths = [ ];
      };
    };
}
