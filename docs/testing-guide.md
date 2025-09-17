# Testing Guide

This guide provides instructions for testing your NixOS configurations across different systems.

## Configuration Testing

### Test Commands

#### 1. Test Flake Structure
```bash
# Check flake syntax and structure
cd nixos
nix flake check
```

#### 2. Test Individual Configurations
```bash
# Test laptop configuration
nixos-rebuild build --flake .#laptop

# Test desktop configuration
nixos-rebuild build --flake .#desktop

# Test server configuration
nixos-rebuild build --flake .#server
```

#### 3. Test Home Manager
```bash
# Test home-manager configuration
home-manager build --flake .#hbohlen
```

### Current Configuration Status

#### ✅ Laptop Configuration (ASUS Zephyrus M16)
- **Hardware:** Intel 11th Gen + NVIDIA RTX 3050 Ti
- **Features:** ASUS services, battery management, hybrid graphics
- **Status:** Ready for deployment
- **Test Command:** `nixos-rebuild build --flake .#laptop`

#### ✅ Desktop Configuration (MSI Z590)
- **Hardware:** Intel 11th Gen + NVIDIA RTX 2070
- **Features:** NVIDIA drivers, multiple displays, virtualization
- **Status:** Ready for deployment
- **Test Command:** `nixos-rebuild build --flake .#desktop`

#### ✅ Server Configuration (Generic VPS)
- **Hardware:** Generic x86_64 server
- **Features:** SSH access, secrets management, headless operation
- **Status:** Ready for deployment (requires secrets encryption)
- **Test Command:** `nixos-rebuild build --flake .#server`

## Testing Checklist

### Pre-Deployment Testing
- [ ] Flake structure is valid (`nix flake check`)
- [ ] All configurations build successfully
- [ ] Home manager builds successfully
- [ ] No syntax errors in any Nix files

### Hardware-Specific Testing
- [ ] Laptop: ASUS services start correctly
- [ ] Desktop: NVIDIA drivers load properly
- [ ] Server: SSH access works with key authentication

### Secrets Testing (Server Only)
- [ ] Age key is properly configured
- [ ] Secrets file is encrypted
- [ ] Secrets decrypt during build
- [ ] Secret files have correct permissions

## Troubleshooting

### Common Issues

#### 1. "experimental Nix feature" errors
```bash
# Enable experimental features
export NIX_CONFIG="experimental-features = nix-command flakes"
```

#### 2. Missing dependencies
```bash
# Install required packages
nix-shell -p git nixFlakes
```

#### 3. SOPS decryption failures
```bash
# Check Age key configuration
age-keygen -o ~/.config/sops/age/keys.txt

# Verify .sops.yaml configuration
cat .sops.yaml
```

#### 4. Hardware-specific failures
- **NVIDIA:** Check kernel modules and driver versions
- **ASUS:** Verify hardware modules are loaded
- **Network:** Test network interfaces

### Debug Commands
```bash
# Check system logs
journalctl -u nixos-rebuild

# Test specific service
systemctl status asusd

# Check NVIDIA status
nvidia-smi

# Verify SSH configuration
sshd -T
```

## Deployment Testing

### Local Testing (Recommended First)
```bash
# Test in VM or container before real deployment
nixos-rebuild build-vm --flake .#server
```

### Remote Deployment Testing
```bash
# Test nixos-anywhere dry run
nixos-anywhere --flake .#server --target-host root@server.example.com --dry-run
```

## Performance Testing

### Boot Time
```bash
# Check boot time
systemd-analyze

# Check critical chain
systemd-analyze critical-chain
```

### Resource Usage
```bash
# Monitor system resources
htop

# Check disk usage
df -h

# Check memory usage
free -h
```

## Related Documentation
- `docs/installation-guide.md` - Installation instructions
- `docs/secrets-management.md` - Secrets setup and usage
- `nixos/README.md` - Configuration overview</content>
</xai:function_call">Create testing guide documentation