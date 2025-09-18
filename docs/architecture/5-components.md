# 5. Components

## Host Configurations
* **Responsibility**: Defines complete system configurations for each target machine
* **Structure**: `hosts/{laptop,desktop,server}/` with `configuration.nix` and `disko.nix`
* **Interfaces**: Available as `nixosConfigurations.<hostname>` in flake outputs

## Shared Modules
* **Responsibility**: Provides reusable configuration components across all hosts
* **Current Modules**:
  - `common.nix`: Base system configuration (GNOME, networking, security)
  - `packages.nix`: System-wide packages (development tools, YubiKey support)
  - `users.nix`: User account configuration
  - `secrets.nix`: Secret management framework
  - `yubikey.nix`: YubiKey authentication support

## User Management
* **Responsibility**: Manages user environments and home directory configurations
* **Structure**: `users/hbohlen/` with `home.nix` for home-manager configuration
* **Integration**: Applied to all hosts via flake configuration

## Secrets Management
* **Responsibility**: Handles secure credential management across hosts
* **Implementation**: 1Password CLI integration with automated secret retrieval
* **Security**: No secrets stored in repository, runtime retrieval only

## Current Component Architecture
```mermaid
graph TD
    subgraph "NixOS Configuration"
        A[flake.nix] --> B{Host Profiles}
        A --> C(Shared Modules)
        A --> D(User Configs)
    end

    B --> B1[ASUS Zephyrus Laptop]
    B --> B2[MSI Z590 Desktop]
    B --> B3[Generic Server]

    C --> B1
    C --> B2
    C --> B3

    D -- home-manager --> B1
    D -- home-manager --> B2
    D -- home-manager --> B3

    subgraph "Hardware Support"
        H1[nixos-hardware: Zephyrus]
        H2[ASUS Services: asusd]
        H3[NVIDIA Drivers]
    end

    H1 --> B1
    H2 --> B1
    H2 --> B2
    H3 --> B2

    subgraph "External Integrations"
        T1[disko - Disk Mgmt]
        T2[1Password CLI - Secrets]
        T3[Podman - Containers]
    end

    T1 --> B1
    T1 --> B2
    T1 --> B3
    T2 --> B1
    T2 --> B2
    T2 --> B3
    T3 --> B1
    T3 --> B2
    T3 --> B3
```

---