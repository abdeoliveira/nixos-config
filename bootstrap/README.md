# Bootstrap a new NixOS machine

## On NEW machine
1. `mkdir -p ~/.ssh`
2. `age -d id_rsa.age > ~/.ssh/id_rsa`   
3. `chmod 600 ~/.ssh/id_rsa`
4. `vim host-specific.nix`
5. `vim flake.nix` (check host name at `nixosConfigurations.nixos`)
6. `cp /etc/nixos/hardware-configuration.nix ~/.nixos-config/`
7. `./temporary-swap.sh`
8. `./reencrypt-keys.sh`
11. `cd ~/.nixos-config && git add . && sudo nixos-rebuild switch --flake .`
12. Import GPG keys for pass

## Optional (to allow new machine to decrypt without id_rsa)
1. Get new machine's host key: `cat /etc/ssh/ssh_host_ed25519_key.pub`
2. Update `secrets/secrets.nix` with new host key
3. Rekey: `RULES=./secrets/secrets.nix agenix -r`
4. Commit and push
