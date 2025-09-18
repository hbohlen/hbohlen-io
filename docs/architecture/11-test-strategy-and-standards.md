# 11. Test Strategy and Standards
Current testing approach:

- **Configuration Validation**: `nix flake check` ensures syntax correctness
- **Build Testing**: `nix build` verifies all dependencies resolve
- **CI/CD Validation**: GitHub Actions test configuration builds
- **Manual Testing**: Hardware-specific testing after automated validation
- **Integration Testing**: End-to-end testing on target hardware

Future Epic 4 will implement automated VM testing.

---