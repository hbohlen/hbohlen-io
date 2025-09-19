# NixOS Installation Guide

## Prerequisites
- NixOS installation media (USB drive)
- Target hardware with internet connection
- Backup of important data (disk operations are destructive)

## Installation Steps

### 1. Boot from Installation Media
1. Insert NixOS installation USB drive
2. Boot the system and select "NixOS" from the boot menu
3. Wait for the system to boot to the command line

### 2. Prepare the System
```bash
# Set keyboard layout (if needed)
loadkeys us

# Enable networking
sudo systemctl start NetworkManager
sudo nmtui

# Verify internet connection
ping google.com
```

### 3. Clone the Configuration
```bash
# Install git (if not available)
nix-shell -p git

# Clone the configuration repository
git clone <repository-url> nixos-config
cd nixos-config
```

### 4. Run Deployment Preparation
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Prepare deployment
./scripts/prepare-deployment.sh
```

### 5. Partition Disks
**WARNING: This will destroy all data on the target disks!**

```bash
# For laptop
sudo nix run --no-write-lock-file github:nix-community/disko -- --mode disko ./result-disko-laptop

# For desktop
sudo nix run --no-write-lock-file github:nix-community/disko -- --mode disko ./result-disko-desktop

# For server
sudo nix run --no-write-lock-file github:nix-community/disko -- --mode disko ./result-disko-server
```

### 6. Install NixOS
```bash
# For laptop
sudo nixos-install --flake .#laptop

# For desktop
sudo nixos-install --flake .#desktop

# For server
sudo nixos-install --flake .#server
```

### 7. Post-Installation
```bash
# Reboot the system
sudo reboot

# After reboot, run hardware compatibility test
./scripts/test-hardware-compatibility.sh
```

## Troubleshooting

### Common Issues
1. **Disk partitioning fails**: Ensure disks are not mounted and you have sufficient permissions
2. **Network issues**: Verify NetworkManager is running and configured properly
3. **Build failures**: Check flake inputs are up to date and dependencies are available

### Getting Help
- Check the NixOS manual: https://nixos.org/manual/nixos/stable/
- Visit the NixOS Discord: https://discord.gg/nixos
- Review the configuration files for any syntax errors

## Verification
After installation, verify the system is working correctly:
- All services are running
- Hardware is detected and functioning
- User accounts are accessible
- Network connectivity is established
- Persistence is working correctly