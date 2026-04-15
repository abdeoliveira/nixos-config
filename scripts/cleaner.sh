#!/usr/bin/env bash

# Define directories to clean
DOWNLOADS_DIR="/home/oliveira/Downloads"
SCREENSHOTS_DIR="/home/oliveira/Downloads/screenshots"
TAILSDROP_DIR="/home/oliveira/Downloads/Tailsdrop"

# Clean Downloads folder if it exists
if [ -d "$DOWNLOADS_DIR" ]; then
  find "$DOWNLOADS_DIR" -mindepth 1 -mmin +1440 -delete -o -type d -empty -delete
fi

mkdir -p TAILSDROP_DIR
