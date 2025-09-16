# Epic List

## Core Project Epics

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

## Future Scope

* **Epic 4: Full Automation & Optimization**
    * **Goal:** Drastically reduce system administration overhead by implementing a fully automated CI pipeline for configuration testing and deployment.
