# 7. Source Tree

```plaintext
hbohlen-io/
├── nixos/
│   ├── flake.nix
│   ├── flake.lock
│   ├── README.md
│   ├── .gitignore
│   ├── secrets/
│   │   └── secrets.yaml.sops
│   ├── scripts/
│   │   └── install.sh
│   ├── hosts/
│   │   ├── laptop/
│   │   │   ├── configuration.nix
│   │   │   └── disko.nix
│   │   └── ... (desktop, server)
│   ├── modules/
│   │   ├── hardware/
│   │   ├── programs/
│   │   ├── services/
│   │   └── profiles/
│   └── users/
│       └── hbohlen/
│           ├── home.nix
│           └── dotfiles/
├── apps/
│   └── (Future projects and services will live here)
└── packages/
    └── (Future shared libraries will live here)
```

---