# Bootstrap a new NixOS machine

## On NEW machine
1.  Edit `/etc/nixos/configuration.nix`: include `vim`, `git`, `age` and enable `openssh`. 
2. `nixos-rebuild switch`
3. `./setup-ssh.sh`
4. `vim ../host-specific.nix` (check if it needs modifications)
5. `cp /etc/nixos/hardware-configuration.nix ~/.nixos-config/`
6. `sudo ./temporary-swap.sh`
7. `cat /etc/ssh/ssh_host_ed25519_key.pub` and update `system=` at `../secrets/secrets.nix`
8. `./reencrypt-keys.sh`
9. `cd ~/.nixos-config && git add . && sudo nixos-rebuild switch --flake .`
10. Import GPG keys for pass

## Optional (but worth checking!)
1. `vim flake.nix` (check host name, `.nixos`, at `nixosConfigurations.nixos`)
