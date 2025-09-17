#!/bin/bash
# Secrets Setup Script
# This script helps you set up SOPS encryption for your secrets

set -e

echo "🔐 Setting up SOPS secrets encryption..."
echo

# Check if sops is installed
if ! command -v sops &> /dev/null; then
    echo "❌ SOPS is not installed. Installing..."
    # Try to install sops
    if command -v nix &> /dev/null; then
        nix-shell -p sops
    else
        echo "Please install SOPS: https://github.com/mozilla/sops"
        exit 1
    fi
fi

# Check if Age key exists
AGE_KEY_DIR="$HOME/.config/sops/age"
AGE_KEY_FILE="$AGE_KEY_DIR/keys.txt"

if [ ! -f "$AGE_KEY_FILE" ]; then
    echo "🔑 Generating Age key for encryption..."
    mkdir -p "$AGE_KEY_DIR"
    age-keygen -o "$AGE_KEY_FILE"
    echo "✅ Age key generated at: $AGE_KEY_FILE"
    echo
    echo "📋 Your Age public key (add this to .sops.yaml):"
    grep "public key:" "$AGE_KEY_FILE" | cut -d' ' -f4
    echo
    echo "⚠️  IMPORTANT: Update .sops.yaml with your public key before proceeding!"
    read -p "Press Enter after updating .sops.yaml..."
fi

# Check if .sops.yaml is configured
if grep -q "age1..." .sops.yaml; then
    echo "❌ .sops.yaml still contains placeholder key!"
    echo "Please update .sops.yaml with your actual Age public key."
    exit 1
fi

# Encrypt the secrets
echo "🔒 Encrypting secrets..."
cd nixos/secrets
sops --encrypt secrets.yaml > secrets.enc.yaml

echo "✅ Secrets encrypted successfully!"
echo "📁 Encrypted file: nixos/secrets/secrets.enc.yaml"
echo
echo "🗑️  REMOVING unencrypted secrets file..."
rm secrets.yaml
echo "✅ Unencrypted secrets removed for security"
echo
echo "📝 Next steps:"
echo "1. Commit the encrypted secrets: git add nixos/secrets/secrets.enc.yaml"
echo "2. Test your server configuration: nixos-rebuild build --flake .#server"
echo "3. Deploy to VPS when ready!"
echo
echo "🎉 Secrets setup complete!"