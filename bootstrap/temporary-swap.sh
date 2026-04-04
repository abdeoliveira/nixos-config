#!/usr/bin/env bash
fallocate -l 16G /swapfile-temp
chmod 600 /swapfile-temp
mkswap /swapfile-temp
swapon /swapfile-temp
