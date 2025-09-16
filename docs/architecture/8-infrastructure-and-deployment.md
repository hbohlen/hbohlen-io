# 8. Infrastructure and Deployment
The primary Infrastructure as Code (IaC) is the Nix configuration itself. Deployment is handled via a Git-based promotion flow, where changes are merged to `main`, pulled on the target host, and activated with `nixos-rebuild switch`. Rollbacks are handled by NixOS's built-in generation management.

---