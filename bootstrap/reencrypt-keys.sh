#!/usr/bin/env bash
cd ~/.nixos-config
RULES=./secrets/secrets.nix \
  nix --extra-experimental-features 'nix-command flakes' \
  run github:ryantm/agenix -- -r -i ~/.ssh/id_rsa
