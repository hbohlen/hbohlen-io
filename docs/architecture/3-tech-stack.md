# 3. Tech Stack

## Cloud Infrastructure
* **Provider**: Provider Agnostic (Initial targets: Hetzner, DigitalOcean)
* **Key Services**: Generic Compute (Linux VPS), Block Storage, DNS
* **Deployment Regions**: User-defined at deployment time (e.g., `us-east`, `fsn1-dc14`)

## Technology Stack Table
| Category | Technology | Version | Purpose | Rationale |
| :--- | :--- | :--- | :--- | :--- |
| OS / Language | NixOS / Nix | `nixpkgs-24.05` | Declarative OS & package management | Core of the project for reproducibility. |
| Config Mgmt | Nix Flakes | Stable | Hermetic builds & dependency mgmt | Provides true reproducibility and version pinning. |
| User Env Mgmt | Home Manager | `0.40.0` | Declarative user dotfiles/packages | Ensures user environment is consistent across hosts. |
| Disk Mgmt | `disko` | `0.4.0` | Declarative disk partitioning | Automates and reproduces disk layouts. |
| Secrets Mgmt | `sops-nix` | `0.5.0` | Build-time secret decryption | Securely integrates secrets into the declarative build. |
| Interactive Secrets| 1Password CLI | `2.26.1` | Interactive user secret access | Provides convenient access to personal vaults for non-system tasks. |
| Version Control | Git | `2.45.1` | Source code management | Standard for version control. |
| CI/CD | GitHub Actions| N/A | Automated testing and checks | Specified in PRD Epic 4 for future automation. |
| VM Testing | NixOS VM Tests| N/A | Pre-deployment validation | Built-in NixOS feature for robust, automated testing. |

---