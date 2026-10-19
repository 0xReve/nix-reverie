# Placeholder NixOS account. Rename / replace when adding a real user.
{ config, ... }:
{
  flake.modules.nixos."users/example" = {
    users.users.example = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      # hashedPassword = "..."; # mkpasswd -m sha-512
    };

    home-manager.users.example = config.flake.modules.homeManager."users/example";
  };
}
