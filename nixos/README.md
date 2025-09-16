# NixOS Configuration

This directory contains all the NixOS configuration files for this project, managed using Nix Flakes.

## Directory Structure

- `flake.nix`: The entry point for the Nix Flake, defining inputs and outputs.
- `hosts/`: Contains host-specific configurations (e.g., hardware settings).
- `users/`: Contains user-specific configurations and home-manager settings.
- `modules/`: Contains shared NixOS modules that can be imported by different hosts or users.
- `secrets/`: Contains encrypted secrets managed by `sops-nix`.
- `scripts/`: Contains utility scripts for managing the configuration.