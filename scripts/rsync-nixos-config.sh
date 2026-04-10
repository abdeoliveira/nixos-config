#!/usr/bin/env bash

rsync -avH --delete \
	--exclude=hardware-configuration.nix \
	/home/oliveira/.nixos-config/ \
	/home/oliveira/Sync/nixos-config
