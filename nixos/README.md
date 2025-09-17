# NixOS Configuration

This directory contains all the NixOS configuration files for this project, managed using Nix Flakes.

## Current Setup

- **Primary Host:** ASUS Zephyrus M16 laptop (`laptop`)
- **Nixpkgs Version:** `nixos-unstable`
- **Hardware Modules:** `nixos-hardware` for ASUS-specific support
- **User Management:** Home Manager for user `hbohlen`
- **Disk Management:** Disko for declarative partitioning

## Directory Structure

- `flake.nix`: The entry point for the Nix Flake, defining inputs and outputs.
- `hosts/`: Contains host-specific configurations (e.g., hardware settings).
  - `laptop/`: ASUS Zephyrus M16 configuration
    - `configuration.nix`: Main system configuration
    - `disko.nix`: Disk partitioning (Btrfs on /dev/nvme0n1)
- `users/`: Contains user-specific configurations and home-manager settings.
  - `hbohlen/`: Home Manager configuration for user hbohlen
- `modules/`: Contains shared NixOS modules that can be imported by different hosts or users.
- `secrets/`: Contains encrypted secrets managed by `sops-nix`.
- `scripts/`: Contains utility scripts for managing the configuration.

## Usage

### Building and Switching Configuration

```bash
# From the nixos/ directory
sudo nixos-rebuild switch --flake .#laptop
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

## Hardware-Specific Features

The ASUS Zephyrus M16 configuration includes:
- **NVIDIA Graphics:** Kernel parameters for backlight control and graphics switching
- **ASUS Battery Management:** 80% charge limit and battery optimization
- **ASUS Services:** asusd daemon for hardware control, supergfxd for graphics switching
- **Latest Kernel:** linuxPackages_latest for best hardware support

## Adding New Hosts

1. Create new directory under `hosts/`
2. Add configuration.nix and disko.nix
3. Update flake.nix outputs
4. Test with `nixos-rebuild build --flake .#newhost`