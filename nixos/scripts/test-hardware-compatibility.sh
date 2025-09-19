#!/bin/bash
# Hardware Compatibility Testing Script
# This script tests various hardware components and services

set -e

echo "=== NixOS Hardware Compatibility Test ==="
echo "Testing Date: $(date)"
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo ""

# Test 1: CPU Information
echo "1. Testing CPU Information..."
lscpu | grep -E "(Model name|Architecture|CPU\(s\)|Thread|Core)"
echo ""

# Test 2: Memory Information
echo "2. Testing Memory Information..."
free -h
echo ""

# Test 3: Disk Information
echo "3. Testing Disk Information..."
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,LABEL
echo ""

# Test 4: Network Interfaces
echo "4. Testing Network Interfaces..."
ip addr show | grep -E "^[0-9]+|inet "
echo ""

# Test 5: Graphics Information
echo "5. Testing Graphics Information..."
if command -v lspci &> /dev/null; then
    lspci | grep -i vga
    echo ""
    if command -v glxinfo &> /dev/null; then
        echo "OpenGL Information:"
        glxinfo | grep -E "(OpenGL vendor|OpenGL renderer|OpenGL version)"
    fi
else
    echo "lspci not available, skipping graphics test"
fi
echo ""

# Test 6: Audio Devices
echo "6. Testing Audio Devices..."
if command -v pactl &> /dev/null; then
    pactl list short sinks
else
    echo "PulseAudio/PipeWire not available, skipping audio test"
fi
echo ""

# Test 7: Bluetooth Devices
echo "7. Testing Bluetooth Devices..."
if command -v bluetoothctl &> /dev/null; then
    echo "Bluetooth service status:"
    systemctl is-active bluetooth
    echo ""
    echo "Bluetooth devices:"
    bluetoothctl devices 2>/dev/null || echo "No bluetooth devices found or bluetooth not available"
else
    echo "Bluetooth not available"
fi
echo ""

# Test 8: Virtualization Support
echo "8. Testing Virtualization Support..."
if command -v kvm-ok &> /dev/null; then
    kvm-ok
else
    echo "kvm-ok not available, checking /dev/kvm..."
    if [ -e /dev/kvm ]; then
        echo "KVM is available"
        ls -la /dev/kvm
    else
        echo "KVM is not available"
    fi
fi
echo ""

# Test 9: Container Support
echo "9. Testing Container Support..."
if command -v podman &> /dev/null; then
    echo "Podman version:"
    podman --version
    echo ""
    echo "Testing podman info:"
    podman info 2>/dev/null | head -10
else
    echo "Podman not available"
fi
echo ""

# Test 10: Gaming Support
echo "10. Testing Gaming Support..."
if command -v steam &> /dev/null; then
    echo "Steam is installed"
else
    echo "Steam not found"
fi

if command -v gamemoded &> /dev/null; then
    echo "Gamemode is installed"
    echo "Gamemode status:"
    systemctl is-active gamemoded
else
    echo "Gamemode not found"
fi
echo ""

# Test 11: System Services Status
echo "11. Testing System Services Status..."
services=("NetworkManager" "pipewire" "tailscaled" "libvirtd" "podman" "flatpak")
for service in "${services[@]}"; do
    if systemctl list-units --all | grep -q "$service.service"; then
        status=$(systemctl is-active "$service" 2>/dev/null || echo "inactive")
        echo "$service: $status"
    else
        echo "$service: not installed"
    fi
done
echo ""

# Test 12: Hardware Sensors
echo "12. Testing Hardware Sensors..."
if command -v sensors &> /dev/null; then
    echo "Sensor information:"
    sensors 2>/dev/null | head -20 || echo "No sensor data available"
else
    echo "lm-sensors not available"
fi
echo ""

# Test 13: Filesystem Mounts
echo "13. Testing Filesystem Mounts..."
mount | grep -E "(persist|tmpfs|ext4|btrfs)" | head -10
echo ""

# Test 14: User Groups
echo "14. Testing User Groups..."
echo "Current user groups:"
groups
echo ""
echo "Checking required groups:"
required_groups=("wheel" "networkmanager" "video" "audio" "input" "libvirtd")
for group in "${required_groups[@]}"; do
    if groups | grep -q "\b$group\b"; then
        echo "✓ $group: OK"
    else
        echo "✗ $group: Missing"
    fi
done
echo ""

# Test 15: NixOS Configuration
echo "15. Testing NixOS Configuration..."
echo "System state version:"
cat /etc/os-release | grep PRETTY_NAME
echo ""
echo "Nix channels:"
nix-channel --list 2>/dev/null || echo "No channels configured"
echo ""
echo "System generations:"
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | head -5 || echo "Unable to list system generations"
echo ""

echo "=== Hardware Compatibility Test Complete ==="
echo "Review the output above for any issues or missing components."