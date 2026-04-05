# Bootstrap a new NixOS machine

## On NEW machine
1.  Edit `/etc/nixos/configuration.nix`: include `vim`, `git`, `age` and enable `openssh`. 
2. `nixos-rebuild switch`
3. `mkdir -p ~/.ssh`
4. `age -d id_rsa.age > ~/.ssh/id_rsa`   
5. `chmod 600 ~/.ssh/id_rsa`
6. `vim ../host-specific.nix` (check if it needs modifications)
7. `cp /etc/nixos/hardware-configuration.nix ~/.nixos-config/`
8. `sudo ./temporary-swap.sh`
9. `cat /etc/ssh/ssh_host_ed25519_key.pub` and update `system=` at `../secrets/secrets.nix`
10. `./reencrypt-keys.sh`
11. `cd ~/.nixos-config && git add . && sudo nixos-rebuild switch --flake .`
12. Import GPG keys for pass

## Optional (but worth checking!)
1. `vim flake.nix` (check host name, `.nixos`, at `nixosConfigurations.nixos`)
