# Epic 3: Server Deployment & Remote Productivity

**Expanded Goal:** This epic extends our reproducible environment to the cloud. We will create a generic, headless server profile that can be deployed to any VPS, focusing on remote productivity and project hosting. A key part of this epic will be integrating a robust secrets management solution to handle sensitive data securely in a non-interactive environment.

---

### Story 3.1: Create Generic Server Profile
* **As a** system administrator, **I want** to create a generic, headless server profile, **so that** I can deploy a consistent base configuration to any remote VPS.
* **Acceptance Criteria:**
    1.  A new host profile for a generic server (e.g., `hosts/server`) is created.
    2.  The profile reuses the shared modules for users and common packages.
    3.  The profile explicitly does **not** include any hardware-specific or graphical user interface modules.
    4.  The profile includes essential server-side tools (e.g., `htop`, `curl`, `wget`).

### Story 3.2: Integrate Secrets Management
* **As a** developer, **I want** to integrate `sops-nix` for secrets management, **so that** I can securely deploy sensitive credentials to my servers.
* **Acceptance Criteria:**
    1.  The `sops-nix` package is added as an input to the `flake.nix`.
    2.  At least one encrypted secrets file is created and committed to the repository.
    3.  The server profile is configured to decrypt and provision a secret (e.g., a placeholder API key) during the system build.

### Story 3.3: Configure Server Firewall and SSH
* **As a** system administrator, **I want** to configure a basic firewall and secure SSH access for the server profile, **so that** the remote machine is secure by default.
* **Acceptance Criteria:**
    1.  The NixOS firewall is enabled on the server profile.
    2.  Only essential ports (e.g., port 22 for SSH) are opened.
    3.  SSH is configured to disallow password-based logins, requiring public key authentication.

### Story 3.4: Deploy Server Configuration to a VPS
* **As a** system administrator, **I want** to deploy the server configuration to a target VPS, **so that** I have a functional, remotely managed server.
* **Acceptance Criteria:**
    1.  The deployment process to a live VPS using a tool like `nixos-anywhere` is successful.
    2.  The VPS boots into the correct configuration.
    3.  The user can successfully SSH into the server using key-based authentication.
    4.  The provisioned secret from Story 3.2 is present and correctly decrypted on the server.
