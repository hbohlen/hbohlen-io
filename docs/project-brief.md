# Project Brief - NixOS Configuration

## Executive Summary

This project aims to create a declarative and version-controlled system for managing NixOS configurations and personal dotfiles across multiple machines, including a desktop, a laptop, and various servers. The primary problem being solved is the complexity and manual effort required to maintain consistent, reproducible, and synchronized environments across different hardware and system roles. The target user for this project is Hayden Bohlen (`hbohlen`), making this a personal infrastructure-as-code initiative. The key value proposition is to achieve a fully automated, modular, and easily deployable system configuration that eliminates configuration drift and simplifies the setup of new machines.

## Problem Statement

**Current State & Pain Points:**
Managing system configurations, installed software, and personal dotfiles across multiple distinct machines (a desktop, an ASUS laptop, and VPS servers) is currently a manual and fragmented process. This leads to "configuration drift," where each system slowly becomes different, causing inconsistencies and unexpected behavior. Setting up a new machine is a time-consuming and error-prone task that relies on memory and manual execution of setup scripts.

**Impact of the Problem:**
* **Time Inefficiency:** Significant time is spent on repetitive administrative tasks like installing packages, syncing dotfiles, and troubleshooting environment-specific issues.
* **Lack of Reproducibility:** It is difficult or impossible to perfectly replicate a working environment, which complicates system recovery and new machine setup.
* **Inconsistency:** Differences in package versions or configurations between machines can lead to tools working on one system but failing on another, hindering productivity.

**Why Existing Solutions Fall Short:**
* **Traditional Dotfile Repositories:** While helpful, they only manage user-level configurations and do not handle system-level packages, services, or hardware-specific settings in a unified way.
* **Imperative Configuration Management (e.g., Ansible, Chef):** These tools can manage system state but are often less cohesive than NixOS's declarative model, which integrates system configuration, user environment, and package management into a single atomic unit.

## Proposed Solution

**Core Concept and Approach:**
The proposed solution is to create a single, unified GitHub repository to serve as the source of truth for all system configurations. This will be built using the NixOS ecosystem, leveraging Flakes for reproducible builds and dependency management. The configuration will be highly modular, separating definitions for each host (desktop, laptop, VPS), user (`hbohlen`), and reusable software components. Declarative disk partitioning will be handled by `disko`, and user-level dotfiles and applications will be managed by `home-manager`, integrating them seamlessly into the overall system configuration.

**Key Differentiators:**
* **Holistic & Declarative:** Unlike managing separate dotfiles or using imperative scripts, this approach defines the *entire desired state* of a system—from the hardware layout to the command-line prompt—in a single, auditable location.
* **Atomic Updates & Rollbacks:** NixOS Flakes provide the ability to update systems atomically. An update either succeeds completely or not at all, preventing broken, partially-configured states and allowing for easy rollbacks to any previous known-good configuration.
* **True Reproducibility:** Any machine, new or old, can be provisioned to an identical, predictable state simply by pointing it to the configuration repository and the desired host profile.

**High-Level Vision:**
The vision is to achieve a "hands-off," fully automated personal infrastructure where any machine's configuration can be audited, updated, rolled back, or replicated from a single source of truth in Git. This will significantly reduce administrative overhead, enforce consistency, and create a robust, future-proof foundation for all personal and professional development environments.

## Target Users

**Primary User Segment: The Developer & System Administrator (Hayden Bohlen)**

* **Profile:** A software developer and power user who manages a personal fleet of diverse computer systems, including a primary desktop, a portable laptop, and remote servers for various tasks.
* **Current Behaviors:** Works across multiple environments and currently relies on manual methods or fragmented scripts to maintain system configurations and personal dotfiles. This leads to time spent on system administration rather than on development or other primary tasks.
* **Needs & Pain Points:**
    * **Need:** A single, reliable source of truth for all system and application configurations.
    * **Need:** A fast and perfectly reproducible method for setting up a new machine or recovering an existing one.
    * **Pain Point:** Wasted productivity from "configuration drift," where inconsistencies between machines cause unexpected errors and require manual troubleshooting.
* **Goals:** To automate personal system administration, enforce absolute consistency across all environments, and build a resilient, long-term foundation for all development work.

## Goals & Success Metrics

**Project Objectives**
* **Phase 1 (Immediate Priority):** Achieve a successful, stable, and bootable NixOS installation on the ASUS ROG Zephyrus M16 laptop, specifically overcoming the known Intel VMD/bootloader hardware issues.
* **Phase 2 (Replication):** Once the laptop configuration is stable, replicate the installation successfully on the desktop machine, adapting for hardware-specific differences.
* **Phase 3 (Expansion):** After the local machines are stable, expand the configuration to include modular profiles for VPS servers and flakes for other specialized build environments (e.g., containers).
* **Phase 4 (Optimization):** After all target systems are configured, achieve the long-term efficiency goals, such as reducing new machine provisioning time to under 30 minutes.

**User Success Metrics**
* **Immediate Success:** Successfully booting into a self-configured NixOS environment on the problematic laptop hardware without errors.
* **Long-Term Success:** Increased confidence in system stability, a reduction in time spent on administration, and the ability to easily experiment with new configurations.

**Key Performance Indicators (KPIs)**
* **Primary KPI:** A successful, error-free boot of NixOS on the laptop following the initial installation. (Pass/Fail)
* **Secondary KPI:** A successful, error-free boot of NixOS on the desktop. (Pass/Fail)
* **Long-Term KPIs:**
    * Time-to-Ready for New Machine: Target of < 30 minutes.
    * Manual Configuration Interventions: Target of 0 required manual changes post-initial setup.
    * Time to Rollback a Faulty Change: Target of < 5 minutes.

## MVP Scope

**Core Features (Must Have)**
* A foundational `flake.nix` file defining inputs for `nixpkgs`, `home-manager`, and `disko`.
* A `disko.nix` configuration tailored specifically for the ASUS ROG Zephyrus M16 laptop's hardware.
* A NixOS configuration for the laptop that defines a bootable system with a user account, networking, and essential services.
* A minimal `home-manager` configuration for the `hbohlen` user to prove the integration is working (e.g., setting the default shell).

**Out of Scope for MVP**
* Configuration for the desktop machine.
* Configurations for any VPS servers.
* Specialized flakes for containers or other build environments.
* Comprehensive dotfile management beyond the initial test case.

**MVP Success Criteria**
* The primary success criterion is a complete and error-free installation of NixOS on the ASUS ROG Zephyrus M16 laptop, specifically overcoming the previous bootloader issues. The system must boot successfully into a usable environment where the `hbohlen` user can log in.

## Post-MVP Vision

**Phase 2 Features**
* Once the laptop installation is successful (MVP), the next immediate step is to replicate the configuration on the desktop machine. This involves creating a second, host-specific profile while reusing as much of the modular configuration as possible.

**Expansion Opportunities**
* After both the laptop and desktop are stable, the project will expand to include configurations for remote VPS servers. This will involve creating profiles that are non-hardware-specific and tailored for a server environment.
* Further expansion includes creating specialized flakes for reproducible development environments or for building container images.
* Add a full virtualization stack using KVM and QEMU to enable running local virtual machines.

**Long-term Vision**
* The long-term vision is to achieve a fully automated personal infrastructure where all systems are managed from a single source of truth in Git. The process will be optimized to the point where provisioning a new machine becomes a trivial, sub-30-minute task, and system-wide updates are handled with a single commit.

## Technical Considerations

**Platform Requirements**
* **Target Platforms:** NixOS (initially version 25.05) on x86_64 architecture, specifically for a custom desktop, an ASUS ROG Zephyrus M16 GU603ZW laptop, and various VPS environments.
* **Browser/OS Support:** Not applicable, as this is a system-level configuration project, not web-based software.
* **Performance Requirements:** Initial builds and deployments should complete in a reasonable timeframe. Specific performance metrics are not an initial goal.

**Technology Preferences**
* **Configuration Stack:** The entire system will be managed using the Nix ecosystem, including NixOS, Flakes for reproducibility, Disko for declarative partitioning, and Home Manager for user-level dotfiles.
* **Hosting/Infrastructure:** The configuration repository will be hosted on GitHub. The infrastructure consists of the user's physical hardware and third-party VPS providers.

**Architecture Considerations**
* **Repository Structure:** A modular monorepo structure will be used to logically separate configurations for hosts, users, and reusable modules.
* **Service Architecture:** Not applicable, as this is not a service-based application.
* **Security/Compliance:** Secrets (API keys, private credentials) must not be stored in plaintext in the Git repository. A dedicated secrets management solution (like `sops-nix`) is recommended.

## Constraints & Assumptions

**Constraints**
* **Budget:** As a personal project, there is no formal budget. However, any cloud services (like VPSs) should aim to use free-tier or low-cost options.
* **Timeline:** There is no hard deadline; the timeline is flexible and dependent on your available personal time.
* **Resources:** The primary resource is your own time for learning, implementation, and maintenance.
* **Technical:** The project is constrained by the specific hardware of the target machines, most notably the Intel VMD controller on the ASUS laptop, which must be successfully worked around.

**Key Assumptions**
* It is assumed that the Intel VMD controller on the ASUS laptop can be successfully disabled via a BIOS setting, making the NVMe drive visible to the NixOS installer.
* It is assumed that the hardware on all target machines (desktop, laptop, VPS) is fundamentally compatible with a standard NixOS installation.
* It is assumed that you have the necessary administrative (root) access to all target machines to perform the installation.

## Risks & Open Questions

**Key Risks**
* **Laptop Hardware Compatibility:** The primary risk to the MVP is the known hardware incompatibility of the ASUS ROG Zephyrus M16 laptop, specifically concerning the Intel VMD controller and NVIDIA PRIME graphics, which could cause the installation to fail.

**Areas Needing Further Research**
* Initial research has uncovered existing NixOS hardware modules that provide solutions for the key hardware challenges:
    * A module to manage the **ASUS battery charge limit** (`battery.nix`)
    * A module to configure **NVIDIA PRIME graphics switching**, including a "battery saver" mode (`prime.nix`).
    * A module to safely manage **power-saving tools** like TLP and prevent conflicts with modern power daemons.
    * A module to enable **SSD TRIM** for drive health and performance.