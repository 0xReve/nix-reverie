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

## Commands

```bash
nix develop
nix flake check
nh os build -H example .
```

`nh`, `nixfmt`, `deadnix`, and `statix` ship via the `tools` aspect (on `example`). Swap the example host and user for real ones.

## License

MIT - see [LICENSE](LICENSE).
