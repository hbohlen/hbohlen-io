# NixOS Test Environment

This directory contains a QEMU-based test environment for safely testing NixOS configurations, including disko partitioning and impermanence setup.

## Setup

1. Ensure you have Nix and QEMU available:
   ```bash
   nix develop  # Enter the dev shell with QEMU
   ```

2. Run the setup script:
   ```bash
   cd nixos/test-environments
   ./setup-test-vm.sh
   ```

   This will:
   - Create a 30GB virtual disk (`test-disk.img`)
   - Build the NixOS VM configuration
   - Start the VM

## Testing Disko Partitioning

Inside the VM:
1. Check disk: `lsblk`
2. Test disko dry-run: `sudo disko-install --dry-run`
3. Apply partitioning: `sudo disko-install`
4. Reboot and verify persistence works

## Configuration

- `test-vm.nix`: VM-specific configuration
- `test-disko.nix`: Disk layout for virtual environment
- `setup-test-vm.sh`: Setup and run script

## Cleanup

To remove test files:
```bash
rm test-disk.img
rm -rf result
```