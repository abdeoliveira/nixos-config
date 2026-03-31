#!/usr/bin/env bash

TARGET="/tmp/external-hd"
HOST="phone"

if [ ! -f "$TARGET/.backup_drive" ]; then
    echo "Backup disc is not available."
    exit 1
fi

if ! ssh -q -o ConnectTimeout=2 "$HOST" exit; then
    echo "Can't connect to '$HOST'."
    exit 1
fi


rsync -avP --delete phone:~/storage/dcim/ $TARGET/data/phone/dcim/

rsync -avP --delete --exclude=.thumbnails phone:~/storage/pictures/ $TARGET/data/phone/pictures/


