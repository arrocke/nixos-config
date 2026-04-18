# NixOS Config

## Scripts

- `./scripts/edit-secrets.sh` - Edit secrets with neovim and encrypt them on exit.
- `./scripts/update-keys.sh` - Add or remove keys that can decrypt secrets.
- `./scripts/generate-host-key.sh` - Generate an `age` key from the host SSH key.
- `./scripts/generate-user-key.sh` - Generate and save an `age` key from the user SSH key.

## Adding a new machine to the secrets manager.

1. Make sure a host ssh key and user ssh key have been generated.
2. Generate and save an `age` key for the current user: `./scripts/generate-user-key.sh`
1. Generate an `age` key with the host public SSH key: `./scripts/generate-host-key.sh`
2. Add key to `.sops.yaml`. Update both `keys` and `creation_rules.key_groups` like the other keys.
3. Execute `./scripts/update-keys.sh` to update the encryption to support the new key.

## Useful Links

- [sops-nix](https://github.com/Mic92/sops-nix) - For managing secrets in nix files.

## Backups

### Create a new backup pool

```bash
sudo zpool create backup \
  -o ashift=12 \
  -O compression=zstd \
  -O atime=off \
  -O xattr=sa \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=file:///run/secrets/zfs-key \
  /dev/disk/by-id/usb-XXXX
```

### Backup

Import and mount the encrypted backup drive
```bash
sudo zpool import -l backup
```

Run the sync script
```bash
syncoid --no-sync-snap zdata/immich backup/immich
```

