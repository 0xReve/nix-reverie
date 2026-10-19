# Lightweight host eval checks (no toplevel / unfree driver builds).
# Live under perSystem.checks so they merge with treefmt/pre-commit.
{
  self,
  inputs,
  ...
}:
let
  npLib = inputs.nixpkgs.lib;
in
{
  perSystem =
    { pkgs, ... }:
    {
      checks = npLib.mapAttrs' (
        hostName: _cfg:
        npLib.nameValuePair "eval-${hostName}" (
          let
            hostConfig = self.nixosConfigurations.${hostName}.config;
            failedAssertions = builtins.filter (a: !a.assertion) hostConfig.assertions;
            checkErrors = npLib.filter (m: m != "") [
              (npLib.optionalString (failedAssertions != [ ])
                "failed assertions: ${npLib.concatMapStringsSep "; " (a: a.message) failedAssertions}"
              )
            ];
          in
          pkgs.runCommand "eval-${hostName}" { } ''
            ${npLib.optionalString (checkErrors != [ ]) ''
              echo ${npLib.escapeShellArg (npLib.concatStringsSep "\n" checkErrors)} >&2
              exit 1
            ''}
            echo ${
              npLib.escapeShellArg (
                builtins.toJSON {
                  inherit hostName;
                  inherit (hostConfig.system) stateVersion;
                }
              )
            } > "$out"
          ''
        )
      ) self.nixosConfigurations;
    };
}
