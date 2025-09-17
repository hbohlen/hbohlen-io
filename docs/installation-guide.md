# NixOS Installation Guide

This guide documents the installation process used for the ASUS Zephyrus M16 laptop and can be adapted for other machines.

## ASUS Zephyrus M16 Installation

### Prerequisites
- Bootable NixOS installation media
- Internet connection
- Target disk: `/dev/nvme0n1`

### Installation Steps

1. **Boot into NixOS Live Environment**
   - Boot from NixOS installation USB
   - Ensure you have internet connectivity

2. **Get Git Access:**
   ```bash
   nix-shell -p git
   ```

3. **Navigate to temp directory:**
   ```bash
   cd /tmp
   ```

4. **Clone configuration repository:**
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

5. **Install using disko-install:**
   ```bash
   sudo nix run --experimental-features 'nix-command flakes' \
     'github:nix-community/disko/latest#disko-install' \
     -- --write-efi-boot-entries \
     --flake .#laptop \
     --disk nvme0n1 /dev/nvme0n1
   ```

### Post-Installation Notes

- The system will automatically reboot after installation
- First boot may take longer due to initial configuration
- ASUS-specific services (asusd, supergfxd) will start automatically
- Battery charge limit is set to 80% by default

### Hardware-Specific Configuration

The configuration includes:
- **NVIDIA Graphics:** Kernel parameters for backlight control and graphics switching
- **ASUS Battery Management:** 80% charge limit and battery optimization
- **ASUS Services:** asusd daemon for hardware control, supergfxd for graphics switching
- **Latest Kernel:** linuxPackages_latest for best hardware support

### Troubleshooting

- If graphics don't work properly, check kernel parameters in `configuration.nix`
- Battery management can be adjusted in `hardware.asus.battery.chargeUpto`
- Use `journalctl -u asusd` to check ASUS daemon status

## Adapting for Other Machines

To adapt this process for other machines:

1. Update `disko.nix` with appropriate disk partitioning
2. Modify `configuration.nix` for hardware-specific settings
3. Update flake output name in `flake.nix`
4. Test in VM first if possible

## Related Files
- `nixos/hosts/laptop/disko.nix` - Disk partitioning configuration
- `nixos/hosts/laptop/configuration.nix` - System configuration
- `nixos/flake.nix` - Flake definition with hardware modules</content>
</xai:function_call">Create installation guide documentation