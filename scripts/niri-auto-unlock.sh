#!/usr/bin/env bash
# Niri Auto-unlock Script
# Handles GPG unlock and graceful fallbacks for missing keys/password store

LOG_FILE="/tmp/startup-debug.log"

# Function to log with timestamp
log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Function to log and echo
log_echo() {
    echo "$1"
    log "$1"
}

# Start logging
{
    echo "=== $(date) ==="
    echo "Niri Auto-unlock Script Starting..."

    # Ensure PASSWORD_STORE_DIR has a sane default
    PASSWORD_STORE_DIR="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

    # Check if the required GPG_UNLOCK_KEY variable is set
    if [ -z "$GPG_UNLOCK_KEY" ]; then
        echo "GPG_UNLOCK_KEY environment variable not set."
        echo "Skipping GPG unlock."
        echo "Set it to your GPG key fingerprint to enable this feature."

    # Now, check if that specific GPG key exists
    elif ! gpg --list-secret-keys "$GPG_UNLOCK_KEY" >/dev/null 2>&1; then
        echo "Specific GPG key ($GPG_UNLOCK_KEY) not found."
        echo "Please import the correct GPG secret key."
        echo "Skipping GPG unlock."
        
    elif [ ! -d "$PASSWORD_STORE_DIR" ]; then
        echo "Password store not found at $HOME/.password-store"
        echo "Skipping GPG unlock."

    # The check for the dummy file is still a good idea
    elif [ ! -f "$PASSWORD_STORE_DIR/PASSWORDS/dummy.gpg" ]; then
        echo "Dummy password entry not found at PASSWORDS/dummy"
        echo "Skipping GPG unlock."

    else
        echo "Required GPG key ($GPG_UNLOCK_KEY) and password store found."
        echo "Attempting to unlock GPG keyring..."

        if pass PASSWORDS/dummy >/dev/null; then
            echo "GPG unlocked successfully"
        else
            echo "Failed to unlock GPG (exit code: $?)"
            echo "Starting niri anyway..."
        fi
    fi

    echo "Starting niri..."
} >> "$LOG_FILE" 2>&1

# Give gpg agent some time...
sleep 1

# Start niri
exec niri-session

