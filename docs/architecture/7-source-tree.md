# 7. Source Tree

```plaintext
hbohlen-io/
├── nixos/
│   ├── flake.nix
│   ├── flake.lock
│   ├── hosts/
│   │   ├── laptop/
│   │   │   ├── configuration.nix
│   │   │   └── disko.nix
│   │   ├── desktop/
│   │   │   ├── configuration.nix
│   │   │   └── disko.nix
│   │   └── server/
│   │       ├── configuration.nix
│   │       └── disko.nix
│   ├── modules/
│   │   ├── common.nix
│   │   ├── packages.nix
│   │   ├── users.nix
│   │   ├── secrets.nix
│   │   └── yubikey.nix
│   └── users/
│       └── hbohlen/
│           └── home.nix
├── docs/
│   ├── architecture.md
│   ├── prd/
│   ├── stories/
│   └── qa/
├── scripts/
│   ├── setup-1password-secrets.sh
│   ├── setup-yubikey.sh
│   └── test-yubikey.sh
└── .github/
    └── workflows/
        ├── test-desktop-install.yml
        └── test-disko-install.yml
```

---