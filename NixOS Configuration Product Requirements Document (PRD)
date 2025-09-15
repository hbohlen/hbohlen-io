# NixOS Configuration Product Requirements Document (PRD)

## Goals and Background Context

### Goals

* Achieve a stable, bootable NixOS installation on the primary target hardware (ASUS ROG Zeyhyrus M16 laptop).
* Replicate the installation successfully on the secondary desktop machine, adapting for hardware differences.
* Expand the configuration to include modular, non-hardware-specific profiles for remote VPS servers.
* Optimize the entire process to reduce the time required to provision a new machine to under 30 minutes.

### Background Context

The core problem this project addresses is the complexity and manual effort required to maintain consistent, reproducible, and synchronized environments across multiple machines. The current manual process leads to configuration drift, making system recovery and new machine setups time-consuming and unreliable.

The proposed solution is to create a single, unified GitHub repository using the NixOS ecosystem (including Flakes, `disko`, and `home-manager`). This will serve as a single source of truth, defining the entire desired state of each system declaratively. This approach enables atomic updates, reliable rollbacks, and true reproducibility, effectively automating personal system administration and eliminating inconsistencies.

### Change Log

| Date                | Version | Description      | Author    |
| ------------------- | ------- | ---------------- | --------- |
| 2025-09-15          | 1.0     | Initial PRD draft | John (PM) |

## Requirements

### Functional

1.  **FR1:** The system must generate a complete NixOS configuration from a central `flake.nix` file.
2.  **FR2:** The configuration must be modular, supporting definitions for multiple distinct hosts (e.g., laptop, desktop, servers).
3.  **FR3:** The system must manage user-level dotfiles and applications via `home-manager`, fully integrated into the main system configuration.
4.  **FR4:** The system must utilize `disko` to declaratively define and apply disk partitioning schemes for target machines.
5.  **FR5:** The configuration for the ASUS laptop must incorporate hardware-specific modules for managing battery charge limits, NVIDIA PRIME graphics, and SSD TRIM.
6.  **FR6:** The project must include an installation script that automates the deployment, validates the system state (e.g., drive mounts, user privileges), and provides detailed logging for troubleshooting.

### Non-Functional

1.  **NFR1:** The entire system configuration must be version-controlled within a single Git repository.
2.  **NFR2:** The system must support atomic updates and provide a mechanism for reliable rollbacks to any previous known-good configuration.
3.  **NFR3:** A given host configuration must be fully reproducible, allowing an identical system state to be deployed on new or existing hardware.
4.  **NFR4:** Secrets, such as API keys or private credentials, must not be stored in plaintext within the Git repository and should be managed by a dedicated solution (e.g., `sops-nix`).
5.  **NFR5:** The installation process must successfully accommodate the ASUS laptop's hardware constraints, specifically the Intel VMD controller.

## User Interface Design Goals

Not applicable for this project, as it is a system-level configuration with no graphical user interface.

## Technical Assumptions

* **Repository Structure:** **Monorepo**
* **Service Architecture:** **Declarative Configuration**
* **Testing Requirements:** The primary method of testing for the MVP will be **Build & Deploy Validation**. Post-MVP, the strategy will evolve to include **Full System VM-Based Testing** for automation.
* **Additional Assumptions:**
    * The entire system will be managed using the Nix ecosystem: **NixOS**, **Flakes**, **Disko**, and **Home Manager**.
    * The configuration repository will be hosted on **GitHub**.
    * Secrets will be managed using **`sops-nix`** or a similar dedicated tool.

## Epic List

### Core Project Epics

* **Epic 1: Foundational Setup & Laptop MVP**
    * **Goal:** Deliver a reliable, reproducible, and daily-driver-ready environment on the primary mobile workstation (ASUS Laptop).
    * **Key Deliverables:**
        * A version-controlled, flake-based monorepo structure in Git.
        * A declarative disk partition scheme for the laptop using `disko`.
        * A bootable base NixOS configuration that solves the laptop's specific hardware issues (Intel VMD, NVIDIA, battery).
        * A minimal `home-manager` configuration for the `hbohlen` user.
* **Epic 2: Desktop Configuration & Consistency**
    * **Goal:** Achieve perfect configuration consistency across all personal workstations by extending the core environment to the desktop.
    * **Key Deliverables:**
        * A new, hardware-specific profile for the desktop machine.
        * Refactoring of the initial configuration into shared modules (e.g., common software, user settings) and host-specific modules (e.g., drivers).
        * A consistent user experience and toolset across both the laptop and desktop.
* **Epic 3: Server Deployment & Remote Productivity**
    * **Goal:** Enable remote productivity and project hosting by deploying the unified configuration to headless VPS servers.
    * **Key Deliverables:**
        * A generic, headless server profile that omits all GUI and physical hardware configurations.
        * Integration of a secrets management solution (like `sops-nix`) for handling sensitive data.
        * A reproducible server environment that can be deployed to any target VPS.

### Future Scope

* **Epic 4: Full Automation & Optimization**
    * **Goal:** Drastically reduce system administration overhead by implementing a fully automated CI pipeline for configuration testing and deployment.

## Epic 1: Foundational Setup & Laptop MVP

**Expanded Goal:** This epic is the cornerstone of the project. Its primary objective is to deliver a reliable, reproducible, and daily-driver-ready NixOS environment on the most challenging piece of hardware—the ASUS laptop. We will establish the foundational flake-based monorepo, implement a declarative disk partition scheme, solve all laptop-specific hardware issues, and integrate a minimal user configuration.

---

#### Story 1.1: Initialize Project Repository
* **As a** developer, **I want** to initialize a new Git repository with a flake-based structure, **so that** I have a version-controlled foundation for all future configurations.
* **Acceptance Criteria:**
    1.  A new Git repository is created.
    2.  A `flake.nix` file is created with inputs for `nixpkgs`, `home-manager`, and `disko`.
    3.  A basic `.gitignore` and `README.md` are present.
    4.  A directory structure for `hosts`, `users`, and `modules` is created.

#### Story 1.2: Declarative Laptop Partitioning
* **As a** system administrator, **I want** to define the disk partitioning scheme for the ASUS laptop declaratively using `disko`, **so that** the installation is automated and reproducible.
* **Acceptance Criteria:**
    1.  A `disko.nix` configuration file is created within the laptop's host directory.
    2.  The configuration defines boot, root, and swap partitions for the laptop's NVMe drive.
    3.  The configuration specifies the filesystems for each partition (e.g., ext4 for root).

#### Story 1.3: Base Laptop System Configuration
* **As a** system administrator, **I want** to create a bootable base NixOS configuration for the ASUS laptop, **so that** a minimal, functional OS can be installed.
* **Acceptance Criteria:**
    1.  A `configuration.nix` for the laptop host is created.
    2.  The configuration sets a hostname, timezone, and enables networking.
    3.  The configuration includes the declarative disk layout from Story 1.2.
    4.  The system can be successfully built using `nixos-rebuild build`.

#### Story 1.4: Integrate Laptop Hardware Modules
* **As a** laptop user, **I want** to integrate hardware-specific modules for NVIDIA PRIME, battery charge limits, and SSD TRIM, **so that** my hardware is properly supported and performs optimally.
* **Acceptance Criteria:**
    1.  The laptop's configuration imports and enables the necessary NixOS modules for NVIDIA graphics.
    2.  A module for managing the ASUS battery charge limit is enabled.
    3.  Periodic SSD TRIM is enabled for the NVMe drive.

#### Story 1.5: Basic User Environment with Home Manager
* **As a** user (`hbohlen`), **I want** a basic user environment configured with `home-manager`, **so that** my personal shell and essential tools are available upon login.
* **Acceptance Criteria:**
    1.  The `hbohlen` user account is created in the laptop's configuration.
    2.  A `home.nix` file for the user is created and imported.
    3.  The user's default shell is set (e.g., zsh).
    4.  A few essential packages (e.g., `git`, `neovim`) are installed for the user.

#### Story 1.6: Create Installation & Validation Script
* **As a** system administrator, **I want** an installation script that automates the deployment and validates the system state, **so that** the installation process is reliable and easy to troubleshoot.
* **Acceptance Criteria:**
    1.  A shell script is created to run the `nixos-install` command with the correct flake target.
    2.  The script performs post-install checks to verify that drives are mounted correctly.
    3.  The script provides clear logging for both successful and failed installations.

## Epic 2: Desktop Configuration & Consistency

**Expanded Goal:** The goal of this epic is to achieve perfect configuration consistency by applying the modular framework we built in Epic 1 to your desktop machine. This will prove the reusability of our configuration, refactor shared components, and result in two distinct, hardware-aware systems managed from a single, unified codebase.

---

#### Story 2.1: Create Desktop Host Profile
* **As a** system administrator, **I want** to create a new host profile for my desktop machine, **so that** I can begin defining its unique configuration.
* **Acceptance Criteria:**
    1.  A new directory is created for the desktop host (e.g., `hosts/desktop`).
    2.  A basic `configuration.nix` and `flake.nix` output for the new host are created.
    3.  The new host can be built successfully with minimal default settings.

#### Story 2.2: Refactor Shared Configuration into Modules
* **As a** developer, **I want** to refactor the laptop's configuration to separate shared settings from hardware-specific settings, **so that** they can be reused by the desktop and future hosts.
* **Acceptance Criteria:**
    1.  Common settings (e.g., user account, shell, common packages) are moved from the laptop's configuration into new files under the `modules/` directory.
    2.  The laptop's configuration is updated to import these new shared modules.
    3.  The laptop's configuration continues to build and function exactly as it did before the refactor.

#### Story 2.3: Apply Shared Modules to Desktop
* **As a** system administrator, **I want** to apply the shared configuration modules to the desktop host profile, **so that** it inherits the common user environment and software.
* **Acceptance Criteria:**
    1.  The desktop's `configuration.nix` is updated to import the shared modules created in Story 2.2.
    2.  The `hbohlen` user account and common software packages are present in the desktop's built configuration.

#### Story 2.4: Define Desktop-Specific Hardware Configuration
* **As a** desktop user, **I want** to define the hardware-specific configuration for my desktop, **so that** its unique components (e.g., different graphics card, audio devices) are properly supported.
* **Acceptance Criteria:**
    1.  A new module for desktop-specific settings (e.g., `hardware-desktop.nix`) is created and imported by the desktop's configuration.
    2.  The configuration includes the necessary drivers and settings for the desktop's unique hardware.

## Epic 3: Server Deployment & Remote Productivity

**Expanded Goal:** This epic extends our reproducible environment to the cloud. We will create a generic, headless server profile that can be deployed to any VPS, focusing on remote productivity and project hosting. A key part of this epic will be integrating a robust secrets management solution to handle sensitive data securely in a non-interactive environment.

---

#### Story 3.1: Create Generic Server Profile
* **As a** system administrator, **I want** to create a generic, headless server profile, **so that** I can deploy a consistent base configuration to any remote VPS.
* **Acceptance Criteria:**
    1.  A new host profile for a generic server (e.g., `hosts/server`) is created.
    2.  The profile reuses the shared modules for users and common packages.
    3.  The profile explicitly does **not** include any hardware-specific or graphical user interface modules.
    4.  The profile includes essential server-side tools (e.g., `htop`, `curl`, `wget`).

#### Story 3.2: Integrate Secrets Management
* **As a** developer, **I want** to integrate `sops-nix` for secrets management, **so that** I can securely deploy sensitive credentials to my servers.
* **Acceptance Criteria:**
    1.  The `sops-nix` package is added as an input to the `flake.nix`.
    2.  At least one encrypted secrets file is created and committed to the repository.
    3.  The server profile is configured to decrypt and provision a secret (e.g., a placeholder API key) during the system build.

#### Story 3.3: Configure Server Firewall and SSH
* **As a** system administrator, **I want** to configure a basic firewall and secure SSH access for the server profile, **so that** the remote machine is secure by default.
* **Acceptance Criteria:**
    1.  The NixOS firewall is enabled on the server profile.
    2.  Only essential ports (e.g., port 22 for SSH) are opened.
    3.  SSH is configured to disallow password-based logins, requiring public key authentication.

#### Story 3.4: Deploy Server Configuration to a VPS
* **As a** system administrator, **I want** to deploy the server configuration to a target VPS, **so that** I have a functional, remotely managed server.
* **Acceptance Criteria:**
    1.  The deployment process to a live VPS using a tool like `nixos-anywhere` is successful.
    2.  The VPS boots into the correct configuration.
    3.  The user can successfully SSH into the server using key-based authentication.
    4.  The provisioned secret from Story 3.2 is present and correctly decrypted on the server.

## Epic 4: Full Automation & Optimization

**Expanded Goal:** This epic focuses on moving from a functional, manually-deployed configuration to a fully automated, hands-off system. The objective is to implement a complete CI/CD pipeline that automatically tests every change in a safe VM environment before it can be merged. This will provide the highest level of confidence in system stability and achieve the long-term goal of sub-30-minute new machine provisioning.

---

#### Story 4.1: Set Up Nix Flake Checker
* **As a** developer, **I want** to integrate a flake checker into a GitHub Actions workflow, **so that** every commit is automatically checked for formatting and validity.
* **Acceptance Criteria:**
    1.  A GitHub Actions workflow is created.
    2.  The workflow triggers on every push to the repository.
    3.  A job within the workflow runs `nix flake check`.
    4.  The action fails if the flake check reports errors.

#### Story 4.2: Implement Automated VM Build Test
* **As a** developer, **I want** the CI pipeline to automatically build the full configuration for each host, **so that** I can catch build failures before deployment.
* **Acceptance Criteria:**
    1.  A new job is added to the GitHub Actions workflow.
    2.  The job builds the complete NixOS configuration for the laptop, desktop, and server profiles.
    3.  The job fails if any of the host builds fail.

#### Story 4.3: Implement Automated VM Boot Test
* **As a** system administrator, **I want** to implement a fully automated VM-based boot test for a host configuration, **so that** I can verify the system not only builds but is also bootable and functional.
* **Acceptance Criteria:**
    1.  A NixOS VM test file is created for the generic server profile.
    2.  The test successfully builds and boots the server configuration in a QEMU virtual machine.
    3.  A basic command (e.g., `whoami`) runs successfully inside the VM to prove it is responsive.

#### Story 4.4: Automate Validation Script in VM Test
* **As a** system administrator, **I want** to automate the execution of my validation script within the VM boot test, **so that** drive mounts, user privileges, and services are automatically verified on every change.
* **Acceptance Criteria:**
    1.  The VM test from Story 4.3 is extended to run the validation script from Epic 1.
    2.  The test passes only if the validation script completes with a success exit code.
    3.  The logs from the script are captured in the CI output.

## Checklist Results Report

_This section will be populated after the PM Checklist is run._

## Next Steps

_This section will be populated after the PM Checklist is run._
