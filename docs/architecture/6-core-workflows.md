# 6. Core Workflows

## Workflow 1: New Machine Installation
```mermaid
sequenceDiagram
    actor Administrator
    participant InstallScript as "scripts/install.sh"
    participant LiveISO as "Target Machine (Live ISO)"
    participant GitHub

    Administrator->>LiveISO: Boot into NixOS Installer
    Administrator->>LiveISO: Run `nix-shell -p git`
    LiveISO-->>Administrator: Provides temporary shell with git
    Administrator->>LiveISO: git clone <repo_url>
    Administrator->>InstallScript: Execute ./install.sh --flake .#<hostname>

    InstallScript->>GitHub: Fetch flake sources
    InstallScript->>LiveISO: Run Pre-flight Checks (VMD, Disks)
    alt Checks Pass
        InstallScript->>LiveISO: Run disko to partition disks
        InstallScript->>LiveISO: Run nixos-install for the flake target
        InstallScript->>LiveISO: Run Post-flight Validation
        InstallScript-->>Administrator: Log Success and prompt for reboot
    else Checks Fail
        InstallScript-->>Administrator: Log detailed error and exit
    end
```

## Workflow 2: System Update and Rollback
```mermaid
sequenceDiagram
    actor Administrator
    participant LocalRepo as "Local Git Repo"
    participant GitHub
    participant TargetHost as "Target Host (e.g., Laptop)"

    Administrator->>LocalRepo: Edit Nix configuration
    Administrator->>LocalRepo: git commit & git push
    LocalRepo->>GitHub: Pushes changes

    Administrator->>TargetHost: SSH into machine

    par Update and Rollback
        section Update Process
            TargetHost->>GitHub: git pull
            Administrator->>TargetHost: sudo nixos-rebuild switch
            TargetHost-->>Administrator: Activates new configuration
        end

        section Rollback Process
            Administrator->>TargetHost: sudo nixos-rebuild switch --rollback
            TargetHost-->>Administrator: Immediately activates previous configuration
        end
    end
```

## Workflow 3: Updating a Shared Module
```mermaid
sequenceDiagram
    actor Administrator
    participant LocalRepo as "Local Git Repo"
    participant GitHub
    participant Laptop
    participant Desktop

    Administrator->>LocalRepo: Edit a SHARED module (e.g., programs/development.nix)
    Administrator->>LocalRepo: git commit & git push
    LocalRepo->>GitHub: Pushes change to central repo

    Note over Laptop,Desktop: At different times, on each machine...

    Administrator->>Laptop: git pull && sudo nixos-rebuild switch
    Laptop->>GitHub: Pulls latest config
    Laptop-->>Administrator: Builds with updated shared module

    Administrator->>Desktop: git pull && sudo nixos-rebuild switch
    Desktop->>GitHub: Pulls latest config
    Desktop-->>Administrator: Builds with SAME updated shared module
```

---