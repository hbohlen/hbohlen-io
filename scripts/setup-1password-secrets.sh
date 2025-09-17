#!/bin/bash
# 1Password Secrets Setup Script
# This script retrieves secrets from 1Password and makes them available to NixOS

set -e

echo "🔐 Setting up 1Password secrets integration..."
echo

# Check if 1Password CLI is installed
if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI is not installed."
    echo "Please install it from: https://developer.1password.com/docs/cli/"
    exit 1
fi

# Check if user is signed in to 1Password
if ! op account list &> /dev/null; then
    echo "❌ Not signed in to 1Password CLI."
    echo "Please sign in using: op signin"
    echo "Or ensure the 1Password desktop app is running."
    exit 1
fi

echo "✅ 1Password CLI is authenticated"
echo

# Define the vault name (you may need to change this)
VAULT_NAME="Personal"  # Change this to your actual vault name

# Check if vault exists
if ! op vault list | grep -q "$VAULT_NAME"; then
    echo "❌ Vault '$VAULT_NAME' not found."
    echo "Available vaults:"
    op vault list
    echo
    echo "Please update VAULT_NAME in this script or create the vault."
    exit 1
fi

echo "📁 Using vault: $VAULT_NAME"
echo

# Create secrets directory if it doesn't exist
SECRETS_DIR="nixos/secrets"
mkdir -p "$SECRETS_DIR"

# Function to get secret from 1Password
get_secret() {
    local item_name="$1"
    local field_name="$2"

    echo "🔍 Retrieving $item_name ($field_name)..."

    if op item get "$item_name" --vault "$VAULT_NAME" --fields "$field_name" 2>/dev/null; then
        echo "✅ Found $item_name"
        return 0
    else
        echo "⚠️  $item_name not found in vault"
        return 1
    fi
}

# Create a temporary file for secrets
TEMP_SECRETS="/tmp/nixos-secrets.json"

# Start building the secrets JSON
cat > "$TEMP_SECRETS" << 'EOF'
{
  "_comment": "Secrets retrieved from 1Password",
  "github_token": "",
  "openai_api_key": "",
  "database": {
    "host": "localhost",
    "username": "admin",
    "password": ""
  },
  "ssh_private_key": "",
  "wireguard_private_key": "",
  "tailscale_auth_key": "",
  "server": {
    "api_key": "",
    "webhook_secret": ""
  }
}
EOF

echo "🔑 Retrieving secrets from 1Password..."
echo

# Retrieve each secret
# GitHub Token
if GITHUB_TOKEN=$(get_secret "GitHub" "token" 2>/dev/null); then
    jq --arg token "$GITHUB_TOKEN" '.github_token = $token' "$TEMP_SECRETS" > "${TEMP_SECRETS}.tmp" && mv "${TEMP_SECRETS}.tmp" "$TEMP_SECRETS"
fi

# OpenAI API Key
if OPENAI_KEY=$(get_secret "OpenAI" "api_key" 2>/dev/null); then
    jq --arg key "$OPENAI_KEY" '.openai_api_key = $key' "$TEMP_SECRETS" > "${TEMP_SECRETS}.tmp" && mv "${TEMP_SECRETS}.tmp" "$TEMP_SECRETS"
fi

# Database Password
if DB_PASSWORD=$(get_secret "Database" "password" 2>/dev/null); then
    jq --arg pwd "$DB_PASSWORD" '.database.password = $pwd' "$TEMP_SECRETS" > "${TEMP_SECRETS}.tmp" && mv "${TEMP_SECRETS}.tmp" "$TEMP_SECRETS"
fi

# SSH Private Key
if SSH_KEY=$(get_secret "SSH Key" "private_key" 2>/dev/null); then
    jq --arg key "$SSH_KEY" '.ssh_private_key = $key' "$TEMP_SECRETS" > "${TEMP_SECRETS}.tmp" && mv "${TEMP_SECRETS}.tmp" "$TEMP_SECRETS"
fi

# WireGuard Private Key
if WG_KEY=$(get_secret "WireGuard" "private_key" 2>/dev/null); then
    jq --arg key "$WG_KEY" '.wireguard_private_key = $key' "$TEMP_SECRETS" > "${TEMP_SECRETS}.tmp" && mv "${TEMP_SECRETS}.tmp" "$TEMP_SECRETS"
fi

# Tailscale Auth Key
if TS_KEY=$(get_secret "Tailscale" "auth_key" 2>/dev/null); then
    jq --arg key "$TS_KEY" '.tailscale_auth_key = $key' "$TEMP_SECRETS" > "${TEMP_SECRETS}.tmp" && mv "${TEMP_SECRETS}.tmp" "$TEMP_SECRETS"
fi

# Server API Key
if SERVER_API_KEY=$(get_secret "Server API" "api_key" 2>/dev/null); then
    jq --arg key "$SERVER_API_KEY" '.server.api_key = $key' "$TEMP_SECRETS" > "${TEMP_SECRETS}.tmp" && mv "${TEMP_SECRETS}.tmp" "$TEMP_SECRETS"
fi

# Server Webhook Secret
if WEBHOOK_SECRET=$(get_secret "Server API" "webhook_secret" 2>/dev/null); then
    jq --arg secret "$WEBHOOK_SECRET" '.server.webhook_secret = $secret' "$TEMP_SECRETS" > "${TEMP_SECRETS}.tmp" && mv "${TEMP_SECRETS}.tmp" "$TEMP_SECRETS"
fi

# Convert JSON to YAML format for NixOS
echo "🔄 Converting secrets to YAML format..."
cat > "$SECRETS_DIR/secrets.yaml" << EOF
# 🔐 SECRETS FROM 1PASSWORD
# This file is generated automatically - DO NOT EDIT MANUALLY
# Generated on: $(date)
EOF

# Add each secret to YAML
if [ -n "$GITHUB_TOKEN" ]; then
    echo "github_token: \"$GITHUB_TOKEN\"" >> "$SECRETS_DIR/secrets.yaml"
fi

if [ -n "$OPENAI_KEY" ]; then
    echo "openai_api_key: \"$OPENAI_KEY\"" >> "$SECRETS_DIR/secrets.yaml"
fi

if [ -n "$DB_PASSWORD" ]; then
    cat >> "$SECRETS_DIR/secrets.yaml" << EOF
database:
  host: "localhost"
  username: "admin"
  password: "$DB_PASSWORD"
EOF
fi

if [ -n "$SSH_KEY" ]; then
    cat >> "$SECRETS_DIR/secrets.yaml" << EOF
ssh_private_key: |
$(echo "$SSH_KEY" | sed 's/^/  /')
EOF
fi

if [ -n "$WG_KEY" ]; then
    echo "wireguard_private_key: \"$WG_KEY\"" >> "$SECRETS_DIR/secrets.yaml"
fi

if [ -n "$TS_KEY" ]; then
    echo "tailscale_auth_key: \"$TS_KEY\"" >> "$SECRETS_DIR/secrets.yaml"
fi

if [ -n "$SERVER_API_KEY" ] || [ -n "$WEBHOOK_SECRET" ]; then
    cat >> "$SECRETS_DIR/secrets.yaml" << EOF
server:
EOF
    if [ -n "$SERVER_API_KEY" ]; then
        echo "  api_key: \"$SERVER_API_KEY\"" >> "$SECRETS_DIR/secrets.yaml"
    fi
    if [ -n "$WEBHOOK_SECRET" ]; then
        echo "  webhook_secret: \"$WEBHOOK_SECRET\"" >> "$SECRETS_DIR/secrets.yaml"
    fi
fi

# Clean up temporary file
rm -f "$TEMP_SECRETS"

echo "✅ Secrets retrieved and saved to: $SECRETS_DIR/secrets.yaml"
echo
echo "📋 Summary of retrieved secrets:"
echo "   - GitHub Token: $([ -n "$GITHUB_TOKEN" ] && echo "✅" || echo "❌")"
echo "   - OpenAI API Key: $([ -n "$OPENAI_KEY" ] && echo "✅" || echo "❌")"
echo "   - Database Password: $([ -n "$DB_PASSWORD" ] && echo "✅" || echo "❌")"
echo "   - SSH Private Key: $([ -n "$SSH_KEY" ] && echo "✅" || echo "❌")"
echo "   - WireGuard Key: $([ -n "$WG_KEY" ] && echo "✅" || echo "❌")"
echo "   - Tailscale Key: $([ -n "$TS_KEY" ] && echo "✅" || echo "❌")"
echo "   - Server API Key: $([ -n "$SERVER_API_KEY" ] && echo "✅" || echo "❌")"
echo "   - Webhook Secret: $([ -n "$WEBHOOK_SECRET" ] && echo "✅" || echo "❌")"
echo
echo "⚠️  IMPORTANT SECURITY NOTES:"
echo "   - The secrets.yaml file contains sensitive information"
echo "   - Add it to .gitignore to prevent accidental commits"
echo "   - Consider encrypting it with SOPS for additional security"
echo
echo "🎉 1Password secrets setup complete!"