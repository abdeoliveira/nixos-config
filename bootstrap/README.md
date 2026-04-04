# Bootstrap a new NixOS machine

## On NEW machine
1. `mkdir -p ~/.ssh`
2. `age -d id_rsa.age > ~/.ssh/id_rsa`   
3. `chmod 600 ~/.ssh/id_rsa`
4. `vim ../host-specific.nix` (check if it needs modifications)
5. `cp /etc/nixos/hardware-configuration.nix ~/.nixos-config/`
6. `./temporary-swap.sh`
7. `cat /etc/ssh/ssh_host_ed25519_key.pub` and update `system=` at `../secrets/secrets.nix`
8. `./reencrypt-keys.sh`
9. `cd ~/.nixos-config && git add . && sudo nixos-rebuild switch --flake .`
10. Import GPG keys for pass

## Optional (but worth checking!)
1. `vim flake.nix` (check host name, `.nixos`, at `nixosConfigurations.nixos`)
