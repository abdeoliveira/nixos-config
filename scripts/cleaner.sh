#!/usr/bin/env bash

# Define directories to clean
DOWNLOADS_DIR="/home/oliveira/downloads"
SCREENSHOTS_DIR="/home/oliveira/downloads/screenshots"
TAILSDROP_DIR="/home/oliveira/downloads/tailsdrop"

# Clean Downloads folder if it exists
if [ -d "$DOWNLOADS_DIR" ]; then
  find "$DOWNLOADS_DIR" -mindepth 1 -mmin +1440 -delete -o -type d -empty -delete
fi

mkdir -p $TAILSDROP_DIR
