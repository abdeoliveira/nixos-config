#!/usr/bin/env bash
RULES=./secrets/secrets.nix \
  nix --extra-experimental-features 'nix-command flakes' \
  run github:ryantm/agenix -- -r -i ~/.ssh/id_rsa
