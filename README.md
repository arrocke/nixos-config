# NixOS Config

## Scripts

`./scripts/edit-secrets.sh` - Edit secrets with neovim and encrypt them on exit.
`./scripts/update-keys.sh` - Add or remove keys that can decrypt secrets.

## Adding a new machine to the secrets manager.

1. Generate an `age` key with the host public SSH key:
  ```bash
  nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
  ```
2. Add key to `.sops.yaml`. Add the key to `creation_rules.key_groups` to enable it to be used on the secrets file.
  ```yaml
  keys:
    - &<hostname> <key>
  creation_rules:
    - key_groups:
        - age:
            - *<hostname>
  ```
3. Execute `./scripts/update-keys.sh` to update the encryption to support the new key.

## Useful Links

- [sops-nix](https://github.com/Mic92/sops-nix) - For managing secrets in nix files.
