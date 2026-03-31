#!/usr/bin/env bash

rsync -avH --delete \
	--exclude=hardware-configuration.nix \
	/etc/nixos/ \
	/home/oliveira/Sync/etc-nixos/
