# NixOS account for reve. Wires HM via homeManager."users/reve".
{ config, ... }:
{
  flake.modules.nixos."users/reve" =
    { pkgs, ... }:
    {
      users.users.reve = {
        isNormalUser = true;
        uid = 1000;
        group = "reve";
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        shell = pkgs.zsh;
        # Avoid programs.zsh.enable (completions collide with nixos-rebuild-ng on 25.11).
        ignoreShellProgramCheck = true;
      };
      environment.shells = [ pkgs.zsh ];
      users.groups.reve.gid = 986;

      nix.settings.trusted-users = [ "reve" ];

      programs.nh.flake = "/home/reve/.config/project-nix";

      home-manager.users.reve = config.flake.modules.homeManager."users/reve";
    };
}
