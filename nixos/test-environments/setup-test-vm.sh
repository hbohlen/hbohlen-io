#!/bin/bash

# Setup and run NixOS test VM for testing disko and impermanence

set -e

echo "Setting up NixOS test VM environment..."

# Create virtual disk if it doesn't exist
if [ ! -f "test-disk.img" ]; then
    echo "Creating virtual disk (30GB)..."
    qemu-img create -f raw test-disk.img 30G
fi

# Build the VM
echo "Building VM from configuration..."
cd ..
nix build .#nixosConfigurations.test-vm.config.system.build.vm

# Run the VM
echo "Starting VM..."
./result/bin/run-nixos-vm

echo "VM setup complete. Test disko partitioning inside the VM."