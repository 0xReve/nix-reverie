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

## Commands

```bash
nix develop
nix flake check
nh os build -H erie .
```

`nh`, `nixfmt`, `deadnix`, and `statix` ship via the `tools` aspect.

## License

MIT - see [LICENSE](LICENSE).
