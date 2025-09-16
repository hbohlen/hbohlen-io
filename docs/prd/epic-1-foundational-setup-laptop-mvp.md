# Epic 1: Foundational Setup & Laptop MVP

**Expanded Goal:** This epic is the cornerstone of the project. Its primary objective is to deliver a reliable, reproducible, and daily-driver-ready NixOS environment on the most challenging piece of hardware—the ASUS laptop. We will establish the foundational flake-based monorepo, implement a declarative disk partition scheme, solve all laptop-specific hardware issues, and integrate a minimal user configuration.

---

### Story 1.1: Initialize Project Repository
* **As a** developer, **I want** to initialize a new Git repository with a flake-based structure, **so that** I have a version-controlled foundation for all future configurations.
* **Acceptance Criteria:**
    1.  A new Git repository is created.
    2.  A `flake.nix` file is created with inputs for `nixpkgs`, `home-manager`, and `disko`.
    3.  A basic `.gitignore` and `README.md` are present.
    4.  A directory structure for `hosts`, `users`, and `modules` is created.

### Story 1.2: Declarative Laptop Partitioning
* **As a** system administrator, **I want** to define the disk partitioning scheme for the ASUS laptop declaratively using `disko`, **so that** the installation is automated and reproducible.
* **Acceptance Criteria:**
    1.  A `disko.nix` configuration file is created within the laptop's host directory.
    2.  The configuration defines boot, root, and swap partitions for the laptop's NVMe drive.
    3.  The configuration specifies the filesystems for each partition (e.g., ext4 for root).

### Story 1.3: Base Laptop System Configuration
* **As a** system administrator, **I want** to create a bootable base NixOS configuration for the ASUS laptop, **so that** a minimal, functional OS can be installed.
* **Acceptance Criteria:**
    1.  A `configuration.nix` for the laptop host is created.
    2.  The configuration sets a hostname, timezone, and enables networking.
    3.  The configuration includes the declarative disk layout from Story 1.2.
    4.  The system can be successfully built using `nixos-rebuild build`.

### Story 1.4: Integrate Laptop Hardware Modules
* **As a** laptop user, **I want** to integrate hardware-specific modules for NVIDIA PRIME, battery charge limits, and SSD TRIM, **so that** my hardware is properly supported and performs optimally.
* **Acceptance Criteria:**
    1.  The laptop's configuration imports and enables the necessary NixOS modules for NVIDIA graphics.
    2.  A module for managing the ASUS battery charge limit is enabled.
    3.  Periodic SSD TRIM is enabled for the NVMe drive.

### Story 1.5: Basic User Environment with Home Manager
* **As a** user (`hbohlen`), **I want** a basic user environment configured with `home-manager`, **so that** my personal shell and essential tools are available upon login.
* **Acceptance Criteria:**
    1.  The `hbohlen` user account is created in the laptop's configuration.
    2.  A `home.nix` file for the user is created and imported.
    3.  The user's default shell is set (e.g., zsh).
    4.  A few essential packages (e.g., `git`, `neovim`) are installed for the user.

### Story 1.6: Create Installation & Validation Script
* **As a** system administrator, **I want** an installation script that automates the deployment and validates the system state, **so that** the installation process is reliable and easy to troubleshoot.
* **Acceptance Criteria:**
    1.  A shell script is created to run the `nixos-install` command with the correct flake target.
    2.  The script performs post-install checks to verify that drives are mounted correctly.
    3.  The script provides clear logging for both successful and failed installations.
