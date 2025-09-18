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
- **Hardware:** ASUS Zephyrus G15 + NVIDIA RTX 3060
- **Features:** ASUS services, battery management (80% limit), hybrid graphics
- **Status:** Deployed and tested
- **Test Command:** `nixos-rebuild build --flake .#laptop`

#### ✅ Desktop Configuration (MSI Z590)
- **Hardware:** MSI Z590 + NVIDIA RTX 2070
- **Features:** ASUS services, NVIDIA drivers, Podman containers, dual monitors
- **Status:** Ready for deployment
- **Test Command:** `nixos-rebuild build --flake .#desktop`

#### ✅ Server Configuration (Generic)
- **Hardware:** Generic x86_64 server
- **Features:** SSH access, 1Password secrets integration, headless operation
- **Status:** Deployed and tested
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

### Secrets Testing (Server/Desktop)
- [ ] 1Password CLI is authenticated
- [ ] Required secrets exist in 1Password vault
- [ ] Secrets retrieval script runs successfully
- [ ] Generated secrets.yaml is properly formatted
- [ ] Secrets load correctly in NixOS configuration

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

#### 3. 1Password CLI failures
```bash
# Check 1Password CLI authentication
op account list

# Test secrets retrieval
./scripts/setup-1password-secrets.sh

# Verify vault access
op vault list
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
# Test disko-install dry run (via GitHub Actions)
# See .github/workflows/test-disko-install.yml

# Manual testing with disko-install
sudo nix run --experimental-features 'nix-command flakes' \
  'github:nix-community/disko/latest#disko-install' \
  -- --flake .#server \
  --disk nvme0n1 /dev/nvme0n1
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