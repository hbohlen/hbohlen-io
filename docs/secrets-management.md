# Secrets Management with SOPS

This document explains how to set up and use SOPS (Secrets OPerationS) for managing encrypted secrets in your NixOS configurations.

## Overview

SOPS allows you to encrypt sensitive data (API keys, passwords, private keys) and store them in your Git repository while keeping the actual values secure. The secrets are automatically decrypted during system builds.

## Prerequisites

1. **Age or GPG key** for encryption/decryption
2. **sops** command-line tool
3. **Age key** (recommended over GPG for simplicity)

## Setup

### 1. Generate Age Key

```bash
# Generate a new Age key pair
age-keygen -o ~/.config/sops/age/keys.txt

# Or create a new key
age-keygen
```

### 2. Configure .sops.yaml

Update `.sops.yaml` with your Age public key:

```yaml
keys:
  - &your_key age1... # Your Age public key here

creation_rules:
  - path_regex: secrets/.*\.yaml$
    key_groups:
      - age:
          - *your_key
```

### 3. Encrypt Secrets

```bash
# Encrypt the secrets file
sops --encrypt nixos/secrets/secrets.yaml > nixos/secrets/secrets.enc.yaml

# Or edit encrypted file directly
sops nixos/secrets/secrets.yaml
```

### 4. Update Configuration

The server configuration is already set up to use the encrypted secrets. The secrets will be automatically decrypted during system builds and made available at:

- `/run/secrets/github_token`
- `/run/secrets/openai_api_key`
- `/run/secrets/database_password`
- `/run/secrets/ssh_private_key`
- `/run/secrets/wireguard_private_key`
- `/run/secrets/tailscale_auth_key`

## Usage in NixOS Configuration

### Accessing Secrets in System Configuration

```nix
{ config, ... }:
{
  # Example: Use GitHub token in a service
  services.some-service.apiKeyFile = config.sops.secrets.github_token.path;

  # Example: Use database password
  services.database.passwordFile = config.sops.secrets.database_password.path;
}
```

### Accessing Secrets in User Environment

```nix
{ config, ... }:
{
  # Example: Set environment variable from secret
  environment.sessionVariables.GITHUB_TOKEN = config.sops.secrets.github_token.path;

  # Example: Use SSH key
  programs.ssh.extraConfig = ''
    IdentityFile ${config.sops.secrets.ssh_private_key.path}
  '';
}
```

## Best Practices

1. **Never commit unencrypted secrets** to the repository
2. **Use different keys for different environments** (dev, staging, prod)
3. **Rotate keys regularly** for security
4. **Limit access** to encryption keys
5. **Test decryption** before deploying to production

## Troubleshooting

### Common Issues

1. **"Failed to decrypt" error:**
   - Check that your Age private key is available
   - Verify `.sops.yaml` configuration
   - Ensure the secret file is properly encrypted

2. **Permission denied:**
   - Check file permissions on Age key file
   - Ensure SSH host key exists for Age SSH key support

3. **Secret not found:**
   - Verify the secret path in `sops.secrets` configuration
   - Check that the secret exists in the encrypted file

### Testing

```bash
# Test decryption
sops --decrypt nixos/secrets/secrets.yaml

# Test NixOS build with secrets
nixos-rebuild build --flake .#server
```

## Security Considerations

- **Key Management:** Store Age private keys securely (password manager, hardware security key)
- **Access Control:** Limit who has access to encryption keys
- **Audit Trail:** SOPS operations are logged and can be audited
- **Backup:** Backup encryption keys separately from the repository

## Related Files

- `.sops.yaml` - SOPS configuration
- `nixos/secrets/secrets.yaml` - Encrypted secrets file
- `nixos/hosts/server/configuration.nix` - Server configuration using secrets</content>
</xai:function_call">Create secrets management documentation