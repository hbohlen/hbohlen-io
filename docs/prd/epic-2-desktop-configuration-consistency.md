# Epic 2: Desktop Configuration & Consistency

**Expanded Goal:** The goal of this epic is to achieve perfect configuration consistency by applying the modular framework we built in Epic 1 to your desktop machine. This will prove the reusability of our configuration, refactor shared components, and result in two distinct, hardware-aware systems managed from a single, unified codebase.

---

### Story 2.1: Create Desktop Host Profile
* **As a** system administrator, **I want** to create a new host profile for my desktop machine, **so that** I can begin defining its unique configuration.
* **Acceptance Criteria:**
    1.  A new directory is created for the desktop host (e.g., `hosts/desktop`).
    2.  A basic `configuration.nix` and `flake.nix` output for the new host are created.
    3.  The new host can be built successfully with minimal default settings.

### Story 2.2: Refactor Shared Configuration into Modules
* **As a** developer, **I want** to refactor the laptop's configuration to separate shared settings from hardware-specific settings, **so that** they can be reused by the desktop and future hosts.
* **Acceptance Criteria:**
    1.  Common settings (e.g., user account, shell, common packages) are moved from the laptop's configuration into new files under the `modules/` directory.
    2.  The laptop's configuration is updated to import these new shared modules.
    3.  The laptop's configuration continues to build and function exactly as it did before the refactor.

### Story 2.3: Apply Shared Modules to Desktop
* **As a** system administrator, **I want** to apply the shared configuration modules to the desktop host profile, **so that** it inherits the common user environment and software.
* **Acceptance Criteria:**
    1.  The desktop's `configuration.nix` is updated to import the shared modules created in Story 2.2.
    2.  The `hbohlen` user account and common software packages are present in the desktop's built configuration.

### Story 2.4: Define Desktop-Specific Hardware Configuration
* **As a** desktop user, **I want** to define the hardware-specific configuration for my desktop, **so that** its unique components (e.g., different graphics card, audio devices) are properly supported.
* **Acceptance Criteria:**
    1.  A new module for desktop-specific settings (e.g., `hardware-desktop.nix`) is created and imported by the desktop's configuration.
    2.  The configuration includes the necessary drivers and settings for the desktop's unique hardware.
