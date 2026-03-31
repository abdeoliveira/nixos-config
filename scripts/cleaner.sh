#!/usr/bin/env bash

# Define directories to clean
DOWNLOADS_DIR="/home/oliveira/Downloads"
SCREENSHOTS_DIR="/home/oliveira/Sync/screenshots"

# Clean Downloads folder if it exists
if [ -d "$DOWNLOADS_DIR" ]; then
  find "$DOWNLOADS_DIR" -mindepth 1 -mmin +1440 -delete -o -type d -empty -delete
fi

# Clean screenshots folder if it exists
if [ -d "$SCREENSHOTS_DIR" ]; then
  find "$SCREENSHOTS_DIR" -mindepth 1 -mmin +2880 -delete
fi

# Delete hidden bash_history tmp files. This command is safe even if no files are found.
#find /home/oliveira -name ".bash_history-*.tmp" -type f -mmin +10080 -delete
