#!/usr/bin/env bash
set -euo pipefail

SRC="${PASSWORD_STORE_DIR:?PASSWORD_STORE_DIR is not set}"
REMOTE_PHONE_DIR=/data/data/com.termux/files/home/storage/shared/password-store

# Refuse anything that isn't a pass store
if [[ ! -f "$SRC/.gpg-id" ]]; then
  echo "refusing to sync: '$SRC' is not a password store" >&2
  exit 1
fi

rsync -avzP --delete "$SRC/" "phone:$REMOTE_PHONE_DIR/"
