#!/bin/bash

SSH_DIR="$HOME/.ssh"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [ -f "id_rsa.age" ]; then
    age -d id_rsa.age > "$SSH_DIR/id_rsa"
    
    chmod 600 "$SSH_DIR/id_rsa"
    echo "Private key decrypted and secured."
else
    echo "Error: id_rsa.age not found in the current directory."
    exit 1
fi

if [ -f "id_rsa.pub" ]; then
    cp id_rsa.pub "$SSH_DIR/"
    
    chmod 644 "$SSH_DIR/id_rsa.pub"
    echo "Public key copied and permissions set."
else
    echo "Warning: id_rsa.pub not found, skipping copy."
fi

echo "SSH key configuration complete."
