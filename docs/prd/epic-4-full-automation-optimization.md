# Epic 4: Full Automation & Optimization

**Expanded Goal:** This epic focuses on moving from a functional, manually-deployed configuration to a fully automated, hands-off system. The objective is to implement a complete CI/CD pipeline that automatically tests every change in a safe VM environment before it can be merged. This will provide the highest level of confidence in system stability and achieve the long-term goal of sub-30-minute new machine provisioning.

---

### Story 4.1: Set Up Nix Flake Checker
* **As a** developer, **I want** to integrate a flake checker into a GitHub Actions workflow, **so that** every commit is automatically checked for formatting and validity.
* **Acceptance Criteria:**
    1.  A GitHub Actions workflow is created.
    2.  The workflow triggers on every push to the repository.
    3.  A job within the workflow runs `nix flake check`.
    4.  The action fails if the flake check reports errors.

### Story 4.2: Implement Automated VM Build Test
* **As a** developer, **I want** the CI pipeline to automatically build the full configuration for each host, **so that** I can catch build failures before deployment.
* **Acceptance Criteria:**
    1.  A new job is added to the GitHub Actions workflow.
    2.  The job builds the complete NixOS configuration for the laptop, desktop, and server profiles.
    3.  The job fails if any of the host builds fail.

### Story 4.3: Implement Automated VM Boot Test
* **As a** system administrator, **I want** to implement a fully automated VM-based boot test for a host configuration, **so that** I can verify the system not only builds but is also bootable and functional.
* **Acceptance Criteria:**
    1.  A NixOS VM test file is created for the generic server profile.
    2.  The test successfully builds and boots the server configuration in a QEMU virtual machine.
    3.  A basic command (e.g., `whoami`) runs successfully inside the VM to prove it is responsive.

### Story 4.4: Automate Validation Script in VM Test
* **As a** system administrator, **I want** to automate the execution of my validation script within the VM boot test, **so that** drive mounts, user privileges, and services are automatically verified on every change.
* **Acceptance Criteria:**
    1.  The VM test from Story 4.3 is extended to run the validation script from Epic 1.
    2.  The test passes only if the validation script completes with a success exit code.
    3.  The logs from the script are captured in the CI output.
