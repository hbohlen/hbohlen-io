# 5. Components

## Hosts Component
* **Responsibility**: Contains the top-level, final configurations for each target machine.
* **Interfaces**: Exposes a `nixosConfigurations.<hostname>` output in the root `flake.nix`.

## Modules Component
* **Responsibility**: The core library containing all reusable and specialized units of configuration.
* **Sub-Components**: Organized into `hardware/`, `programs/`, `services/`, and `profiles/`.

## Users Component
* **Responsibility**: Contains all user-specific configurations, managed by Home Manager.

## Secrets Component
* **Responsibility**: Manages all encrypted sensitive data for the system using `sops-nix`.

## Scripts Component
* **Responsibility**: Contains operational and automation scripts like `install.sh`.

## Component Diagram
```mermaid
graph TD
    subgraph "NixOS Monorepo"
        A[flake.nix]

        subgraph hosts
            direction LR
            H1[laptop]
            H2[desktop]
            H3[server]
        end

        subgraph modules
            direction LR
            M1[hardware/]
            M2[programs/]
            M3[services/]
            M4[profiles/]
        end

        subgraph users
            direction LR
            U1[hbohlen/]
        end

        subgraph secrets
            S1[secrets.yaml.sops]
        end

        subgraph scripts
            SC1[install.sh]
        end

        A -- orchestrates --> hosts
        A -- orchestrates --> modules
        A -- orchestrates --> users

        hosts -- imports from --> modules
        hosts -- imports from --> users
        H3 -- needs --> secrets

        scripts -- operates on --> A
    end
```

---