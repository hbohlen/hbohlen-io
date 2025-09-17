# YubiKey 5 NFC Setup Guide for NixOS

## Overview

The YubiKey 5 NFC is an excellent addition to your security setup. It provides hardware-based authentication that's far more secure than software-based 2FA, and it can significantly reduce password typing through various integrations.

## Why YubiKey 5 NFC?

### Security Benefits
- **Hardware Security**: Keys stored in secure hardware, immune to malware
- **FIDO2/WebAuthn**: Modern passwordless authentication standard
- **Multiple Factors**: Supports U2F, FIDO2, TOTP, static passwords, and more
- **Tamper Resistant**: Physical security features prevent key extraction

### Convenience Benefits
- **Touch Authentication**: Tap instead of typing passwords
- **NFC Support**: Works with mobile devices
- **Multi-Device**: Use across laptop, desktop, and mobile
- **Backup Keys**: Store multiple credentials on one device

## Hardware Setup

### What You'll Need
- YubiKey 5 NFC
- USB-A to USB-C adapter (if needed)
- Backup YubiKey (recommended for redundancy)

### Initial Setup
1. **Insert YubiKey** into your laptop
2. **Set PIN**: Use YubiKey Manager to set a strong PIN
3. **Enable Touch**: Configure touch requirements for different operations

## Software Installation

### Add YubiKey Packages to Your NixOS Configuration

Update your `nixos/modules/packages.nix`:

```nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # YubiKey management
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool

    # PAM integration for system authentication
    pam_yubico

    # SSH agent for YubiKey
    yubikey-agent

    # Additional utilities
    libyubikey
    yubikey-manager-qt  # GUI manager
  ];
}
```

### Enable YubiKey Services

Add to your `configuration.nix`:

```nix
{ config, pkgs, ... }:

{
  # Enable PC/SC daemon for smart card support
  services.pcscd.enable = true;

  # Enable YubiKey for PAM authentication
  security.pam.yubico = {
    enable = true;
    debug = false;
    mode = "challenge-response";
  };

  # Udev rules for YubiKey access
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];
}
```

## 1Password Integration

### Enhanced Security with YubiKey

1Password supports YubiKey for:
- **Account Protection**: Use YubiKey as 2FA for your 1Password account
- **Secret Storage**: Store YubiKey-related secrets in 1Password
- **Passwordless Login**: Use YubiKey for passwordless authentication

### Setup Steps

1. **Add YubiKey to 1Password Account:**
   - Go to 1Password Settings → Security → Two-factor authentication
   - Add Security Key → Insert YubiKey → Touch to register

2. **Store YubiKey Configuration in 1Password:**
   - Create items for:
     - YubiKey PIN
     - YubiKey PUK (if set)
     - Backup codes
     - Recovery information

## SSH Authentication Setup

### Generate SSH Keys on YubiKey

```bash
# Install yubikey-agent if not already done
# Then generate keys:

# Generate Ed25519 key on YubiKey
ykman piv keys generate --algorithm ECCP256 9a pubkey.pem
ykman piv certificates generate --subject "SSH Key" 9a pubkey.pem

# Extract public key for authorized_keys
ykman piv certificates export 9a - | openssl x509 -pubkey -noout
```

### Configure SSH Agent

Create `~/.config/systemd/user/yubikey-agent.service`:

```ini
[Unit]
Description=YubiKey SSH Agent
PartOf=graphical-session.target

[Service]
ExecStart=/run/wrappers/bin/yubikey-agent -l
Restart=always

[Install]
WantedBy=graphical-session.target
```

Enable and start the service:
```bash
systemctl --user enable yubikey-agent
systemctl --user start yubikey-agent
```

### Update SSH Config

Add to `~/.ssh/config`:
```bash
Host *
    IdentityAgent ~/.yubikey-agent.sock
```

## System Authentication (PAM)

### Configure Sudo with YubiKey

Add to your `configuration.nix`:

```nix
{
  security.pam.services.sudo = {
    yubicoAuth = true;
  };
}
```

### Login Authentication

For system login with YubiKey:

```nix
{
  security.pam.services.login = {
    yubicoAuth = true;
  };
}
```

## GPG Integration

### Set Up GPG with YubiKey

```bash
# Generate GPG key on YubiKey
gpg --card-edit

# In the card edit prompt:
# admin
# generate
# Follow prompts to generate key

# Set up GPG agent
echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf
```

## Web Authentication (FIDO2/WebAuthn)

### Browser Setup

1. **Chrome/Chromium**: Automatically detects YubiKey
2. **Firefox**: May need configuration
3. **Safari**: Native support

### Common Websites Supporting YubiKey

- **GitHub**: Use YubiKey for 2FA and SSH
- **GitLab**: Full FIDO2 support
- **Google**: YubiKey as security key
- **Microsoft**: Azure AD and Microsoft accounts
- **AWS**: Hardware MFA
- **Most modern services**: FIDO2/WebAuthn support

## Mobile Integration (NFC)

### Android Setup

1. **Enable NFC** in Android settings
2. **Install YubiKey App** from Google Play
3. **Configure Accounts** that support NFC authentication

### iOS Setup

1. **NFC is built-in** - no additional setup needed
2. **Use Safari** for WebAuthn
3. **Third-party apps** may have limited support

## Backup and Recovery

### Backup Strategy

1. **Secondary YubiKey**: Keep a backup device
2. **Store Recovery Codes**: In 1Password with strong encryption
3. **Document Setup**: Keep setup instructions secure
4. **Test Regularly**: Verify backup keys work

### Recovery Process

If you lose your YubiKey:
1. Use backup YubiKey if available
2. Use recovery codes stored in 1Password
3. Re-register with services using recovery methods
4. Generate new keys and update all services

## Testing Your Setup

### Test Commands

```bash
# Test YubiKey detection
ykman info

# Test OTP functionality
ykman otp info

# Test PIV functionality
ykman piv info

# Test OpenPGP functionality
ykman openpgp info

# Test SSH agent
ssh-add -L

# Test GPG
gpg --card-status
```

### Integration Tests

1. **SSH to server**: `ssh user@server` (should prompt for touch)
2. **Sudo command**: `sudo ls` (should require YubiKey)
3. **Web login**: Try logging into GitHub with YubiKey
4. **1Password**: Verify YubiKey works as 2FA

## Troubleshooting

### Common Issues

1. **YubiKey not detected**:
   - Check USB connection
   - Try different USB port
   - Verify udev rules: `sudo udevadm control --reload-rules`

2. **SSH not working**:
   - Verify agent is running: `systemctl --user status yubikey-agent`
   - Check SSH config: `ssh -v user@host`

3. **PAM authentication failing**:
   - Check PAM config: `grep yubico /etc/pam.d/*`
   - Verify challenge-response mode setup

4. **WebAuthn not working**:
   - Check browser settings
   - Verify FIDO2 support: `ykman fido info`

### Reset YubiKey

⚠️ **WARNING**: This will erase all data on your YubiKey!

```bash
# Reset all interfaces
ykman mode fido+ccid
ykman otp delete 1
ykman otp delete 2
ykman piv reset
ykman openpgp reset
```

## Advanced Configuration

### Custom PIN/PUK

```bash
# Change PIN
ykman piv access change-pin

# Change PUK
ykman piv access change-puk

# Set management key
ykman piv access set-management-key
```

### Multiple Profiles

You can configure different behaviors for different use cases:
- Work vs Personal profiles
- Different PINs for different contexts
- Selective enabling of interfaces

## Security Best Practices

1. **Strong PIN**: Use a long, unique PIN
2. **Physical Security**: Keep YubiKey secure when not in use
3. **Backup**: Always have a backup YubiKey
4. **Regular Updates**: Keep firmware updated
5. **Limited Interfaces**: Only enable interfaces you need
6. **Monitor Usage**: Check logs for suspicious activity

## Integration with Your Current Setup

### With Your NixOS Configuration

Your YubiKey will integrate seamlessly with:
- **SSH access** to your servers
- **System authentication** on all your machines
- **Git operations** with SSH keys
- **Web authentication** for online services
- **1Password** for enhanced account security

### With Your 1Password Workflow

1. Store YubiKey PIN in 1Password
2. Use YubiKey as 2FA for 1Password account
3. Store recovery codes securely
4. Use YubiKey for passwordless authentication where supported

## Next Steps

1. **Order your YubiKey** if you haven't already
2. **Review this guide** and customize for your needs
3. **Test the setup** on your laptop first
4. **Deploy to other machines** (desktop, server)
5. **Update your security documentation**

Would you like me to help you configure any specific aspect of the YubiKey setup?</content>
</xai:function_call">Create comprehensive YubiKey setup guide
</xai:function_call name="edit">
<parameter name="filePath">nixos/modules/packages.nix