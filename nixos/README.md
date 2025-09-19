# NixOS Configuration

This directory contains all the NixOS configuration files for this project, managed using Nix Flakes.

## Current Setup

- **Nixpkgs Version:** `nixos-unstable`
- **Hardware Modules:** `nixos-hardware` for hardware-specific support
- **User Management:** Home Manager for user `hbohlen`
- **Disk Management:** Disko for declarative partitioning
- **Secrets Management:** SOPS-Nix for encrypted secrets

## Host Configurations

### 1. ASUS Zephyrus M16 Laptop (`laptop`)
- **Hardware:** ASUS Zephyrus M16 gaming laptop
- **Storage:** Btrfs on /dev/nvme0n1
- **Special Features:**
  - NVIDIA Graphics with backlight control and graphics switching
  - ASUS Battery Management (80% charge limit)
  - ASUS Services (asusd daemon, supergfxd)
  - Latest kernel for best hardware support

### 2. Desktop Workstation (`desktop`)
- **Hardware:** Generic desktop workstation
- **Storage:** Btrfs on /dev/sda
- **Special Features:**
  - Desktop-optimized configuration
  - Standard graphics drivers
  - Desktop-specific services

### 3. Server (`server`)
- **Hardware:** Generic server hardware
- **Storage:** Btrfs on /dev/vda
- **Special Features:**
  - Server-optimized configuration
  - Minimal desktop environment
  - Server-specific services and security

## Directory Structure

- `flake.nix`: The entry point for the Nix Flake, defining inputs and outputs.
- `hosts/`: Contains host-specific configurations.
  - `laptop/`: ASUS Zephyrus M16 configuration
  - `desktop/`: Desktop workstation configuration  
  - `server/`: Server configuration
- `users/`: Contains user-specific configurations and home-manager settings.
  - `hbohlen/`: Home Manager configuration for user hbohlen
- `modules/`: Contains shared NixOS modules that can be imported by different hosts or users.
- `scripts/`: Contains utility scripts for managing the configuration.

## Usage

### Building and Switching Configuration

```bash
# From the nixos/ directory
sudo nixos-rebuild switch --flake .#laptop    # For laptop
sudo nixos-rebuild switch --flake .#desktop   # For desktop
sudo nixos-rebuild switch --flake .#server    # For server
```

### Testing Configuration

```bash
# Build without switching to test configuration
nixos-rebuild build --flake .#laptop
nixos-rebuild build --flake .#desktop
nixos-rebuild build --flake .#server

# Check flake for errors
nix flake check
```

### Updating Flake Inputs

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
```

### Home Manager

```bash
# Switch home-manager configuration
home-manager switch --flake .#hbohlen
```

### Hardware Compatibility Testing

```bash
# Run hardware compatibility tests
./scripts/test-hardware-compatibility.sh
```

### Deployment Preparation

```bash
# Prepare for deployment
./scripts/prepare-deployment.sh
```

## Host-Specific Features

### Laptop (ASUS Zephyrus M16)
- **NVIDIA Graphics:** Kernel parameters for backlight control and graphics switching
- **ASUS Battery Management:** 80% charge limit and battery optimization
- **ASUS Services:** asusd daemon for hardware control, supergfxd for graphics switching
- **Latest Kernel:** linuxPackages_latest for best hardware support

### Desktop
- **Desktop-optimized configuration** with standard graphics drivers
- **Desktop-specific services** and applications
- **Standard storage layout** optimized for desktop use

### Server
- **Server-optimized configuration** with minimal desktop environment
- **Server-specific services** and security settings
- **Minimal storage layout** optimized for server deployment

## Adding New Hosts

1. Create new directory under `hosts/`
2. Add `default.nix`, `disko.nix`, and `hardware-configuration.nix`
3. Update flake.nix outputs to include new host
4. Test with `nixos-rebuild build --flake .#newhost`
5. Add host to deployment scripts and documentation