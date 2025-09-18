# 8. Infrastructure and Deployment
The system uses NixOS configurations as Infrastructure as Code. Deployment follows a git-based workflow:

- **Initial Installation**: `disko-install` for partitioning and system setup
- **Updates**: `git pull` + `sudo nixos-rebuild switch` on target hosts
- **Rollbacks**: `sudo nixos-rebuild switch --rollback` for immediate reversion
- **Validation**: GitHub Actions CI/CD for configuration testing

All infrastructure runs on local hardware with no cloud dependencies.

---