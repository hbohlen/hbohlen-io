# 11. Test Strategy and Standards
The strategy is **VM-First Validation**. No change is deployed until it successfully builds and boots in a QEMU VM using NixOS's built-in testing framework. This will be automated via GitHub Actions in the future.

---