# Public library: no host configs. Host eval checks live in the machine flake.
{ ... }:
{
  perSystem = { ... }: {
    checks = { };
  };
}
