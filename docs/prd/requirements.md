# Requirements

## Functional

1.  **FR1:** The system must generate a complete NixOS configuration from a central `flake.nix` file.
2.  **FR2:** The configuration must be modular, supporting definitions for multiple distinct hosts (e.g., laptop, desktop, servers).
3.  **FR3:** The system must manage user-level dotfiles and applications via `home-manager`, fully integrated into the main system configuration.
4.  **FR4:** The system must utilize `disko` to declaratively define and apply disk partitioning schemes for target machines.
5.  **FR5:** The configuration for the ASUS laptop must incorporate hardware-specific modules for managing battery charge limits, NVIDIA PRIME graphics, and SSD TRIM.
6.  **FR6:** The project must include an installation script that automates the deployment, validates the system state (e.g., drive mounts, user privileges), and provides detailed logging for troubleshooting.

## Non-Functional

1.  **NFR1:** The entire system configuration must be version-controlled within a single Git repository.
2.  **NFR2:** The system must support atomic updates and provide a mechanism for reliable rollbacks to any previous known-good configuration.
3.  **NFR3:** A given host configuration must be fully reproducible, allowing an identical system state to be deployed on new or existing hardware.
4.  **NFR4:** Secrets, such as API keys or private credentials, must not be stored in plaintext within the Git repository and should be managed by a dedicated solution (e.g., `sops-nix`).
5.  **NFR5:** The installation process must successfully accommodate the ASUS laptop's hardware constraints, specifically the Intel VMD controller.
