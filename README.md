# nix-reverie

Dendritic NixOS **module library**. Machine builds live in a private flake
(this repo's companion is [nix-secrets](https://github.com/0xReve/nix-secrets)).

## Layout

| Path | Role |
|------|------|
| `flake.nix` | Inputs + `import-tree ./modules` |
| `modules/flake/` | Flake spine (aspects, overlays, formatter) |
| `modules/system/` | Reusable system aspects |
| `modules/users/<user>/` | Reusable user aspects (library example: `reve`) |

Exports: `modules` (`flake.modules`), `overlays.default`, formatter / checks.

## Machine flake

Compose a host in a private flake that follows this library:

```nix
inputs.nix-reverie.url = "github:0xReve/nix-reverie";
# local work (sibling under project-nix/):
# inputs.nix-reverie.url = "path:../nix-reverie";
```

Import aspects from `inputs.nix-reverie.modules.nixos` / `.homeManager`, add
personal overlays (disks, locale, sops file, desk stack), and define
`nixosConfigurations.<host>` there. Run `nh` from the private flake.

## Commands (library)

```bash
nix develop
nix flake check
```

## License

MIT - see [LICENSE](LICENSE).
