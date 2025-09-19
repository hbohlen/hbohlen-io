#!/bin/bash
# Deployment Preparation Script
# This script prepares the NixOS configuration for deployment

set -e

echo "=== NixOS Deployment Preparation ==="
echo "Preparation Date: $(date)"
echo ""

# Check if we're in the correct directory
if [ ! -f "flake.nix" ]; then
    echo "Error: flake.nix not found. Please run this script from the nixos directory."
    exit 1
fi

# Step 1: Clean up any previous builds
echo "1. Cleaning up previous builds..."
nix-collect-garbage -d
echo ""

# Step 2: Update flake inputs
echo "2. Updating flake inputs..."
nix flake update
echo ""

# Step 3: Build all configurations
echo "3. Building all configurations..."
echo "Building laptop configuration..."
nix build .#nixosConfigurations.laptop.config.system.build.toplevel --no-link
echo "✓ Laptop configuration built successfully"

echo "Building desktop configuration..."
nix build .#nixosConfigurations.desktop.config.system.build.toplevel --no-link
echo "✓ Desktop configuration built successfully"

echo "Building server configuration..."
nix build .#nixosConfigurations.server.config.system.build.toplevel --no-link
echo "✓ Server configuration built successfully"
echo ""

# Step 4: Generate disko scripts
echo "4. Generating disko partitioning scripts..."
echo "Generating laptop disko script..."
nix build .#nixosConfigurations.laptop.config.system.build.diskoScript --no-link
echo "✓ Laptop disko script generated"

echo "Generating desktop disko script..."
nix build .#nixosConfigurations.desktop.config.system.build.diskoScript --no-link
echo "✓ Desktop disko script generated"

echo "Generating server disko script..."
nix build .#nixosConfigurations.server.config.system.build.diskoScript --no-link
echo "✓ Server disko script generated"
echo ""

# Step 5: Check for any issues
echo "5. Checking for configuration issues..."
nix flake check
if [ $? -eq 0 ]; then
    echo "✓ All configurations passed checks"
else
    echo "✗ Some configurations have issues"
    exit 1
fi
echo ""

# Step 6: Create deployment summary
echo "6. Creating deployment summary..."
echo "=== NixOS Deployment Summary ===" > deployment-summary.txt
echo "Generated on: $(date)" >> deployment-summary.txt
echo "" >> deployment-summary.txt

echo "Configurations built:" >> deployment-summary.txt
echo "- Laptop: ✓" >> deployment-summary.txt
echo "- Desktop: ✓" >> deployment-summary.txt
echo "- Server: ✓" >> deployment-summary.txt
echo "" >> deployment-summary.txt

echo "Disko scripts generated:" >> deployment-summary.txt
echo "- Laptop: ✓" >> deployment-summary.txt
echo "- Desktop: ✓" >> deployment-summary.txt
echo "- Server: ✓" >> deployment-summary.txt
echo "" >> deployment-summary.txt

echo "Flake inputs updated:" >> deployment-summary.txt
nix flake metadata --json | jq -r '.nodes | keys[]' | sed 's/^/- /' >> deployment-summary.txt
echo "" >> deployment-summary.txt

echo "Next steps for deployment:" >> deployment-summary.txt
echo "1. Boot from NixOS installation media" >> deployment-summary.txt
echo "2. Partition disks using the generated disko scripts" >> deployment-summary.txt
echo "3. Install NixOS using the appropriate configuration" >> deployment-summary.txt
echo "4. Reboot into the new system" >> deployment-summary.txt
echo "5. Run the hardware compatibility test script" >> deployment-summary.txt
echo "" >> deployment-summary.txt

echo "✓ Deployment summary created: deployment-summary.txt"
echo ""

# Step 7: Create installation guide
echo "7. Creating installation guide..."
cat > installation-guide.md << 'EOF'
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
EOF

echo "✓ Installation guide created: installation-guide.md"
echo ""

# Step 8: Final verification
echo "8. Final verification..."
echo "Checking flake lock status..."
if git diff --quiet flake.lock; then
    echo "✓ Flake lock is clean"
else
    echo "⚠ Flake lock has been updated"
fi

echo "Checking for uncommitted changes..."
if git diff --quiet; then
    echo "✓ No uncommitted changes"
else
    echo "⚠ There are uncommitted changes"
fi

echo ""
echo "=== Deployment Preparation Complete ==="
echo ""
echo "Generated files:"
echo "- deployment-summary.txt: Summary of prepared configurations"
echo "- installation-guide.md: Step-by-step installation instructions"
echo ""
echo "Next steps:"
echo "1. Review deployment-summary.txt"
echo "2. Follow installation-guide.md for actual deployment"
echo "3. Run test-hardware-compatibility.sh after installation"
echo ""
echo "Ready for deployment!"