# treefmt + git-hooks flakeModules; seeds devShells.default.
{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule
  ];

  perSystem =
    { config, pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          shellcheck.enable = true;
          shfmt.enable = true;
          mdformat.enable = true;
        };
        settings.global.excludes = [
          "assets/**"
        ];
      };

      formatter = config.treefmt.build.wrapper;

      pre-commit = {
        check.enable = true;
        settings = {
          excludes = [ "^assets/" ];
          hooks = {
            treefmt.enable = true;
            deadnix = {
              enable = true;
              excludes = [ "^assets/" ];
            };
            statix.enable = false;
          };
        };
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixfmt
          deadnix
          statix
          nh
        ];
        inputsFrom = [ config.treefmt.build.devShell ];
        shellHook = config.pre-commit.installationScript;
      };
    };
}
