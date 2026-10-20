# nix-reverie

A dendritic NixOS flake that will grow into reverie!

## Layout

| Path | Role |
|------|------|
| `flake.nix` | Inputs + `import-tree ./modules` |
| `modules/flake/` | Flake spine (aspects, hosts, formatter) |
| `modules/system/` | One file per system aspect |
| `modules/hosts/` | One file per host |
| `modules/users/<user>/` | One file per user feature |

## Hosts / users

| Host | User |
|------|------|
| `erie` | `reve` |

Machine-specific disks, locale overrides, and sops files live in a separate
private flake input (`nix-secrets`). Fork this repo, create your own private
secrets repo, and point the `nix-secrets` input at it. Put your
`nixos-generate-config` hardware module under `hosts/<name>/hardware-config.nix`.

## Commands

```bash
nix develop
nix flake check
nh os build -H erie .
```

`nh`, `nixfmt`, `deadnix`, and `statix` ship via the `tools` aspect.

## License

MIT - see [LICENSE](LICENSE).
