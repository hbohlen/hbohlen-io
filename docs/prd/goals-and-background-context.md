# Goals and Background Context

## Goals

* Achieve a stable, bootable NixOS installation on the primary target hardware (ASUS ROG Zeyhyrus M16 laptop).
* Replicate the installation successfully on the secondary desktop machine, adapting for hardware differences.
* Expand the configuration to include modular, non-hardware-specific profiles for remote VPS servers.
* Optimize the entire process to reduce the time required to provision a new machine to under 30 minutes.

## Background Context

The core problem this project addresses is the complexity and manual effort required to maintain consistent, reproducible, and synchronized environments across multiple machines. The current manual process leads to configuration drift, making system recovery and new machine setups time-consuming and unreliable.

The proposed solution is to create a single, unified GitHub repository using the NixOS ecosystem (including Flakes, `disko`, and `home-manager`). This will serve as a single source of truth, defining the entire desired state of each system declaratively. This approach enables atomic updates, reliable rollbacks, and true reproducibility, effectively automating personal system administration and eliminating inconsistencies.

## Change Log

| Date                | Version | Description      | Author    |
| ------------------- | ------- | ---------------- | --------- |
| 2025-09-15          | 1.0     | Initial PRD draft | John (PM) |
