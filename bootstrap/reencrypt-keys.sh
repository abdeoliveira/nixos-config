#!/usr/bin/env bash
cd ~/.nixos-config

# Create necessary directories before home-manager runs
mkdir -p /home/oliveira/.local/state/nix/profiles
mkdir -p /home/oliveira/.local/share
mkdir -p /home/oliveira/.config
chown -R oliveira:users /home/oliveira/.local
chown -R oliveira:users /home/oliveira/.config

# Reencrypt age keys
RULES=./secrets/secrets.nix \
  nix --extra-experimental-features 'nix-command flakes' \
  run github:ryantm/agenix -- -r -i ~/.ssh/id_rsa
