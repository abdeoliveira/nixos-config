#!/usr/bin/env bash

DEST='192.168.2.50'
HOSTNAME=$(hostname)

# Ensure target directory exists on the Mac mini
ssh "$DEST" "mkdir -p /home2/oliveira/$HOSTNAME"

# Perform the sync
rsync -aHv --delete --timeout=10 \
	--exclude=chromium \
	--exclude=.virtual_box \
	--exclude=Trash \
	--exclude=.cache \
	--exclude=Downloads \
	--exclude=torbrowser \
	--exclude=.mozilla \
	/home/oliveira/ "$DEST:/home2/oliveira/$HOSTNAME"

