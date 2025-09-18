# NixOS Installation Guide

This guide documents the installation process for Hayden's NixOS configuration across multiple hosts (laptop, desktop, server).

## Current Implementation Status

**✅ Completed:**
- ASUS Zephyrus M16 laptop (Story 1.2)
- MSI Z590 desktop (Story 2.1) - *Ready for installation*
- Generic server profile (Story 3.1)

**🔄 Next:** Desktop installation and validation

## General Installation Process

### Prerequisites
- Bootable NixOS minimal ISO
- Internet connection
- Target disk identification (use `lsblk` or `fdisk -l`)

### Installation Steps

1. **Boot into NixOS Live Environment**
    - Boot from NixOS minimal ISO USB
    - Ensure internet connectivity

2. **Clone Repository:**
    ```bash
    nix-shell -p git
    cd /tmp
    git clone https://github.com/hbohlen/hbohlen-io
    cd hbohlen-io/nixos
    ```

3. **Install using disko-install:**
    ```bash
    # Replace 'desktop' with your target host (laptop, desktop, server)
    # Replace 'nvme1n1' with your actual disk device
    sudo nix run --experimental-features 'nix-command flakes' \
      'github:nix-community/disko/latest#disko-install' \
      -- --flake .#desktop \
      --disk nvme1n1 /dev/nvme1n1
    ```

**⚠️ Important Notes:**
- **Omit `--write-efi-boot-entries`** - This option causes issues and is not needed
- **Verify disk device** - Use `lsblk` to confirm correct disk (avoid Windows partitions)
- **Target host** - Must match flake output name (laptop, desktop, server)

## Host-Specific Installation

### ASUS Zephyrus M16 Laptop (Completed)

**Command:**
```bash
sudo nix run --experimental-features 'nix-command flakes' \
  'github:nix-community/disko/latest#disko-install' \
  -- --flake .#laptop \
  --disk nvme0n1 /dev/nvme0n1
```

**Hardware Configuration:**
- ASUS Zephyrus G15 with RTX 3060
- Kernel parameters for NVIDIA/graphics switching
- Battery charge limit (80%)
- ASUS services (asusd, supergfxd)

### MSI Z590 Desktop (Ready for Installation)

**Command:**
```bash
sudo nix run --experimental-features 'nix-command flakes' \
  'github:nix-community/disko/latest#disko-install' \
  -- --flake .#desktop \
  --disk nvme1n1 /dev/nvme1n1
```

**Hardware Configuration:**
- MSI Z590 motherboard
- NVIDIA RTX 2070
- ASUS services (asusd for motherboard compatibility)
- Podman container runtime
- Dual-monitor setup

**Disk Layout:**
- EFI partition: 1G (vfat)
- Swap: 32G (encrypted, for 64GB RAM)
- Root: Remaining space (BTRFS)

### Generic Server (Completed)

**Command:**
```bash
sudo nix run --experimental-features 'nix-command flakes' \
  'github:nix-community/disko/latest#disko-install' \
  -- --flake .#server \
  --disk nvme0n1 /dev/nvme0n1
```

**Configuration:**
- SSH server
- 1Password secrets integration
- Basic server packages
- No GUI/desktop environment

## Post-Installation Setup

### For All Hosts

1. **First Boot:**
    - System reboots automatically after installation
    - Login with `hbohlen` / `changeme`
    - Change password immediately: `passwd`

2. **Update System:**
    ```bash
    sudo nixos-rebuild switch
    ```

3. **Verify Services:**
    ```bash
    systemctl status asusd      # ASUS services (if applicable)
    systemctl status supergfxd  # Graphics switching (if applicable)
    systemctl status podman     # Container runtime
    ```

### Host-Specific Verification

**Laptop/Desktop:**
```bash
# Test graphics
nvidia-smi

# Test ASUS services
asusctl profile -p

# Test containers
podman run hello-world
```

**Server:**
```bash
# Test SSH
ssh localhost

# Test secrets (after setup)
sudo nixos-option hb.secrets.github_token
```

## Troubleshooting

### Common Issues

**"disko-install failed"**
- Check disk device name with `lsblk`
- Ensure disk is not mounted or in use
- Verify internet connection for flake resolution

**"NVIDIA graphics not working"**
- Check kernel parameters in host configuration
- Verify NVIDIA drivers loaded: `lsmod | grep nvidia`
- Test with: `glxinfo | grep NVIDIA`

**"ASUS services not starting"**
```bash
# Check service status
systemctl status asusd
journalctl -u asusd

# Restart services
sudo systemctl restart asusd supergfxd
```

**"Podman containers failing"**
```bash
# Check Podman status
systemctl status podman

# Test basic functionality
podman system info
```

### Recovery Options

**Rollback Configuration:**
```bash
sudo nixos-rebuild switch --rollback
```

**Boot from Live ISO:**
- Reboot with NixOS live ISO
- Mount existing installation: `mount /dev/disk/by-label/nixos /mnt`
- Chroot and fix: `nixos-enter`

## Configuration Files Reference

| Host | Configuration | Disk Layout | Notes |
|------|---------------|-------------|-------|
| laptop | `hosts/laptop/configuration.nix` | `hosts/laptop/disko.nix` | ASUS Zephyrus, battery management |
| desktop | `hosts/desktop/configuration.nix` | `hosts/desktop/disko.nix` | MSI Z590, NVIDIA graphics |
| server | `hosts/server/configuration.nix` | `hosts/server/disko.nix` | Generic server, secrets integration |

## Security Considerations

- **Initial Password:** Change `changeme` immediately after first login
- **Secrets Setup:** Run `./scripts/setup-1password-secrets.sh` for server/desktop
- **Firewall:** Default NixOS firewall is enabled
- **Updates:** Regular `sudo nixos-rebuild switch` for security patches

## Next Steps

1. **Complete Desktop Installation** - Test the process documented above
2. **Validate Multi-Host Setup** - Ensure all hosts work consistently
3. **Epic 4 Implementation** - Add CI/CD automation for testing
4. **Documentation Updates** - Update this guide based on installation experience