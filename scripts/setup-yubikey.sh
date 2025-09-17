#!/bin/bash
# YubiKey Initial Setup Script

set -e

echo "🔐 YubiKey Initial Setup"
echo "========================"
echo

# Check if YubiKey is present
if ! ykman info &>/dev/null; then
    echo "❌ No YubiKey detected!"
    echo "Please insert your YubiKey and run this script again."
    exit 1
fi

echo "✅ YubiKey detected:"
ykman info | grep -E "(Device type|Serial number|Firmware version)"
echo

# Function to prompt for confirmation
confirm() {
    local message="$1"
    read -p "$message (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# 1. Set PINs
echo "1. Setting up PINs"
echo "=================="

if confirm "Set a PIN for the PIV interface?"; then
    echo "Setting PIV PIN (default: 123456)..."
    ykman piv access change-pin
    echo "✅ PIV PIN set"
fi

if confirm "Set a PIN for FIDO2?"; then
    echo "Setting FIDO2 PIN..."
    ykman fido access change-pin
    echo "✅ FIDO2 PIN set"
fi

echo

# 2. Generate SSH key
echo "2. SSH Key Generation"
echo "====================="

if confirm "Generate an SSH key on your YubiKey?"; then
    echo "Generating Ed25519 key on slot 9a..."

    # Generate private key
    ykman piv keys generate --algorithm ECCP256 9a pubkey.pem

    # Generate self-signed certificate
    ykman piv certificates generate --subject "CN=SSH Key" 9a pubkey.pem

    # Extract public key
    ykman piv certificates export 9a - | openssl x509 -pubkey -noout > ssh_key.pub

    echo "✅ SSH key generated"
    echo "📄 Public key saved to: ssh_key.pub"
    echo
    echo "Your SSH public key:"
    cat ssh_key.pub
    echo
    echo "Add this key to your servers' authorized_keys files"
fi

echo

# 3. Test functionality
echo "3. Testing Setup"
echo "================"

echo "Testing OTP functionality..."
ykman otp info

echo
echo "Testing FIDO2 functionality..."
ykman fido info

echo
echo "Testing PIV functionality..."
ykman piv info

echo

# 4. Instructions for next steps
echo "4. Next Steps"
echo "============="
echo
echo "🎉 Your YubiKey is configured! Here are the next steps:"
echo
echo "1. Store your PINs securely in 1Password:"
echo "   - Create a new item called 'YubiKey PINs'"
echo "   - Store PIV PIN, FIDO2 PIN, and any other PINs"
echo
echo "2. Add SSH key to your servers:"
echo "   - Copy the public key from ssh_key.pub"
echo "   - Add it to ~/.ssh/authorized_keys on your servers"
echo
echo "3. Test SSH authentication:"
echo "   - Start the YubiKey agent: systemctl --user start yubikey-agent"
echo "   - Try SSH to a server: ssh user@server"
echo
echo "4. Set up with 1Password:"
echo "   - Go to 1Password Settings → Security → Two-factor authentication"
echo "   - Add Security Key and touch your YubiKey"
echo
echo "5. Test web authentication:"
echo "   - Visit https://webauthn.io"
echo "   - Try registering with your YubiKey"
echo
echo "📖 For detailed documentation, see: docs/yubikey-setup.md"
echo
echo "🧪 To test your setup, run: ./scripts/test-yubikey.sh"</content>
</xai:function_call">Create YubiKey setup script
</xai:function_call name="bash">
<parameter name="command">chmod +x scripts/setup-yubikey.sh