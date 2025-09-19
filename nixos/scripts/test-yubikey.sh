#!/bin/bash
# YubiKey Functionality Test Script

set -e

echo "🔐 Testing YubiKey functionality..."
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    local status=$1
    local message=$2
    if [ "$status" -eq 0 ]; then
        echo -e "${GREEN}✅${NC} $message"
    else
        echo -e "${RED}❌${NC} $message"
    fi
}

# Test 1: Check if YubiKey is detected
echo "1. Testing YubiKey detection..."
if ykman info &>/dev/null; then
    print_status 0 "YubiKey detected"
    ykman info | grep -E "(Device type|Serial number|Firmware version)"
else
    print_status 1 "YubiKey not detected"
    echo "   Make sure your YubiKey is inserted"
fi
echo

# Test 2: Check OTP functionality
echo "2. Testing OTP functionality..."
if ykman otp info &>/dev/null; then
    print_status 0 "OTP interface available"
    echo "   OTP slots configured:"
    ykman otp info | grep -E "Slot [12]:"
else
    print_status 1 "OTP interface not available"
fi
echo

# Test 3: Check FIDO2 functionality
echo "3. Testing FIDO2/WebAuthn functionality..."
if ykman fido info &>/dev/null; then
    print_status 0 "FIDO2 interface available"
    ykman fido info | grep -E "(PIN|UV|FIDO2)"
else
    print_status 1 "FIDO2 interface not available"
fi
echo

# Test 4: Check PIV functionality
echo "4. Testing PIV functionality..."
if ykman piv info &>/dev/null; then
    print_status 0 "PIV interface available"
    echo "   PIV certificates:"
    ykman piv certificates list 2>/dev/null | grep -v "No certificates" || echo "   No certificates configured"
else
    print_status 1 "PIV interface not available"
fi
echo

# Test 5: Check OpenPGP functionality
echo "5. Testing OpenPGP functionality..."
if ykman openpgp info &>/dev/null; then
    print_status 0 "OpenPGP interface available"
    ykman openpgp info | grep -E "(OpenPGP|PIN|Admin PIN)"
else
    print_status 1 "OpenPGP interface not available"
fi
echo

# Test 6: Check PC/SC daemon
echo "6. Testing PC/SC daemon..."
if pgrep pcscd &>/dev/null; then
    print_status 0 "PC/SC daemon running"
else
    print_status 1 "PC/SC daemon not running"
    echo "   Run: sudo systemctl start pcscd"
fi
echo

# Test 7: Check udev rules
echo "7. Testing udev rules..."
if lsusb | grep -i yubico &>/dev/null; then
    print_status 0 "YubiKey visible to system"
else
    print_status 1 "YubiKey not visible to system"
    echo "   Check USB connection and udev rules"
fi
echo

# Summary and recommendations
echo "📋 Summary and Recommendations:"
echo

if ykman info &>/dev/null; then
    echo "🎉 Your YubiKey is working! Here are some next steps:"
    echo
    echo "1. Set a strong PIN:"
    echo "   ykman piv access change-pin"
    echo
    echo "2. Configure FIDO2 PIN:"
    echo "   ykman fido access change-pin"
    echo
    echo "3. Generate SSH keys:"
    echo "   ykman piv keys generate --algorithm ECCP256 9a pubkey.pem"
    echo
    echo "4. Test with your browser:"
    echo "   Visit https://webauthn.io and try registration"
    echo
    echo "5. Set up with 1Password:"
    echo "   Add YubiKey as 2FA for your 1Password account"
    echo
else
    echo "⚠️  YubiKey not detected. Troubleshooting steps:"
    echo
    echo "1. Ensure YubiKey is properly inserted"
    echo "2. Try a different USB port"
    echo "3. Check if PC/SC daemon is running: sudo systemctl status pcscd"
    echo "4. Verify udev rules: sudo udevadm control --reload-rules"
    echo "5. Test with: lsusb | grep -i yubico"
fi

echo
echo "📖 For detailed setup instructions, see: docs/yubikey-setup.md"</content>
</xai:function_call">Create YubiKey test script
</xai:function_call name="bash">
<parameter name="command">chmod +x scripts/test-yubikey.sh