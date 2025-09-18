# 3. Tech Stack

## Infrastructure Scope
* **Deployment Target**: Local/personal infrastructure (laptop, desktop, home server)
* **No Cloud Dependencies**: All systems run on local hardware
* **Hardware Focus**: ASUS motherboard compatibility, NVIDIA graphics, general server requirements

## Current Technology Stack
| Category | Technology | Version | Status | Purpose | Rationale |
| :--- | :--- | :--- | :--- | :--- | :--- |
| OS / Language | NixOS / Nix | Unstable | ✅ Implemented | Declarative OS & package management | Core platform providing reproducibility |
| Config Mgmt | Nix Flakes | Latest | ✅ Implemented | Hermetic builds & dependency mgmt | Enables version-pinned, reproducible configurations |
| User Env Mgmt | Home Manager | Latest | ✅ Implemented | Declarative user environments | Consistent user experience across hosts |
| Disk Mgmt | `disko` | Latest | ✅ Implemented | Declarative partitioning | Automated, reproducible disk setup |
| Secrets Mgmt | 1Password CLI | Latest | ✅ Implemented | Secure credential management | User-friendly secrets without complex key infrastructure |
| Hardware Support | nixos-hardware | Latest | ✅ Implemented | ASUS hardware compatibility | Optimized configurations for specific hardware |
| Container Runtime | Podman | Latest | ✅ Implemented | Application containers | Rootless containers with Docker API compatibility |
| Version Control | Git | Latest | ✅ Implemented | Configuration versioning | Full history of system changes |
| CI/CD | GitHub Actions | Latest | 🚧 Planned | Automated validation | Epic 4 implementation for testing automation |

---