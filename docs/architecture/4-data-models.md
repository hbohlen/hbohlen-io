# 4. Data Models

## Host Configuration
* **Purpose**: Defines a complete, buildable machine configuration for specific hardware
* **Attributes**: `hostname`, `system`, `hardwareModules`, `sharedModules`, `userConfig`, `diskLayout`
* **Relationships**: Each host imports shared modules, hardware-specific modules, and user configurations

## User Environment
* **Purpose**: Manages user accounts and home directory configurations via home-manager
* **Attributes**: `username`, `groups`, `initialPassword`, `homeConfig`, `packages`
* **Relationships**: User configurations are shared across compatible hosts with host-specific overrides

## Shared Module
* **Purpose**: Reusable configuration components that work across multiple hosts
* **Attributes**: `name`, `services`, `packages`, `systemConfig`
* **Examples**: `common.nix` (base system), `packages.nix` (shared tools), `users.nix` (account setup)

## Secrets Configuration
* **Purpose**: Manages sensitive data retrieval and system integration
* **Attributes**: `secretType`, `source` (1Password), `targetPath`, `permissions`
* **Implementation**: 1Password CLI integration with YAML-based secret definitions

---