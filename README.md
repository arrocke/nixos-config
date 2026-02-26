# NixOS Config

## Scripts

- `./scripts/edit-secrets.sh` - Edit secrets with neovim and encrypt them on exit.
- `./scripts/update-keys.sh` - Add or remove keys that can decrypt secrets.
- `./scripts/generate-host-key.sh` - Generate an `age` key from the host SSH key.

## Adding a new machine to the secrets manager.

1. Generate an `age` key with the host public SSH key: `./scripts/generate-host-key.sh path/to/ssh/key`
2. Add key to `.sops.yaml`. Update both `keys` and `creation_rules.key_groups` like the other keys.
3. Execute `./scripts/update-keys.sh` to update the encryption to support the new key.

## Useful Links

- [sops-nix](https://github.com/Mic92/sops-nix) - For managing secrets in nix files.
