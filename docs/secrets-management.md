## Using 1Password CLI for Secrets Management

### Setup 1Password CLI

1. **Install 1Password CLI:**
   ```bash
   # On macOS
   brew install 1password-cli

   # On Linux
   curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
     sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
   echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | \
     sudo tee /etc/apt/sources.list.d/1password.list
   sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
   curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
     sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
   sudo apt update && sudo apt install 1password-cli
   ```

2. **Authenticate:**
   ```bash
   # Sign in to 1Password
   op signin

   # Or use service account for CI/CD
   export OP_SERVICE_ACCOUNT_TOKEN=your_token_here
   ```

3. **Create a vault for secrets:**
   ```bash
   # Create a vault for infrastructure secrets
   op vault create "Infrastructure Secrets"
   ```

### Using 1Password in NixOS

#### Automated Setup Script (Recommended)

We've created an automated script that retrieves secrets from 1Password and generates a `secrets.yaml` file for use in your NixOS configurations:

```bash
# Run the setup script
./scripts/setup-1password-secrets.sh

# This will:
# 1. Check 1Password CLI authentication
# 2. Retrieve secrets from your vault
# 3. Generate nixos/secrets/secrets.yaml
# 4. Provide a summary of retrieved secrets
```

**Prerequisites:**
- 1Password CLI installed and authenticated
- A vault named "Personal" (or update the script with your vault name)
- Items in 1Password with specific names:
  - "GitHub" (with field "token")
  - "OpenAI" (with field "api_key")
  - "Database" (with field "password")
  - "SSH Key" (with field "private_key")
  - "WireGuard" (with field "private_key")
  - "Tailscale" (with field "auth_key")
  - "Server API" (with fields "api_key" and "webhook_secret")

**Security Notes:**
- The generated `secrets.yaml` file is added to `.gitignore`
- Consider encrypting it with SOPS for additional security if needed
- The script provides a clear summary of what was retrieved

#### Option 1: Direct CLI Usage in Scripts
```bash
#!/bin/bash
# Example: Get database password
DB_PASSWORD=$(op read "op://Infrastructure Secrets/database/password")

# Use in application
export DATABASE_URL="postgresql://user:$DB_PASSWORD@localhost/db"
```

#### Option 2: Integration with systemd services
```nix
# In your NixOS configuration
systemd.services.myapp = {
  serviceConfig = {
    EnvironmentFile = "/run/secrets/myapp.env";
    ExecStart = "${pkgs.myapp}/bin/myapp";
  };
  preStart = ''
    # Generate environment file from 1Password
    cat > /run/secrets/myapp.env << EOF
    API_KEY=$(op read "op://Infrastructure Secrets/api/key")
    DATABASE_URL=$(op read "op://Infrastructure Secrets/database/url")
    EOF
  '';
};
```

#### Option 3: Using 1Password Connect (for teams)
If you're working with a team, consider 1Password Connect:

```bash
# Run 1Password Connect server
docker run -d \
  --name 1password-connect \
  -p 8080:8080 \
  -v /path/to/credentials.json:/home/opuser/.op/1password-credentials.json \
  1password/connect:latest

# Then use the REST API in your applications
curl -H "Authorization: Bearer $OP_CONNECT_TOKEN" \
  http://localhost:8080/v1/vaults/your-vault-id/items/your-item-id
```

## Bitwarden CLI Alternative

### Setup Bitwarden CLI

1. **Install Bitwarden CLI:**
   ```bash
   # Using npm
   npm install -g @bitwarden/cli

   # Or using snap
   sudo snap install bw
   ```

2. **Login and unlock:**
   ```bash
   bw login
   bw unlock  # This gives you a session key
   export BW_SESSION="your_session_key"
   ```

3. **Usage:**
   ```bash
   # Get a specific item
   bw get item "Database Password"

   # Get password from item
   bw get password "Database Password"

   # List items
   bw list items --search "api"
   ```

### Bitwarden in NixOS

```bash
#!/bin/bash
# Example script using Bitwarden CLI
API_KEY=$(bw get password "API Key")
DATABASE_URL=$(bw get password "Database URL")

# Use in your application
export API_KEY DATABASE_URL
```

## Comparison: 1Password vs Bitwarden vs SOPS

| Feature | 1Password | Bitwarden | SOPS |
|---------|------------|-----------|------|
| **GUI** | ✅ Excellent | ✅ Good | ❌ None |
| **CLI** | ✅ Excellent | ✅ Good | ✅ Excellent |
| **Team Sharing** | ✅ Excellent | ✅ Good | ❌ Manual |
| **Cost** | 💰 Paid | 💰 Free/Paid | ✅ Free |
| **Setup Complexity** | 🟡 Medium | 🟡 Medium | 🔴 High |
| **Container Support** | ✅ Excellent | ✅ Good | ✅ Excellent |
| **Git Integration** | ❌ Not designed for | ❌ Not designed for | ✅ Excellent |
| **Security Model** | 🔐 Centralized | 🔐 Centralized | 🔐 Git-based |

## Recommendation

**For Individual Use:**
- **1Password**: If you already use it and want the best UX
- **Bitwarden**: If you want free option with good CLI support
- **SOPS**: If you want Git-based secrets with maximum security

**For Teams:**
- **1Password**: Best team features and sharing
- **Bitwarden**: Good free tier for small teams
- **SOPS + 1Password/Bitwarden**: Hybrid approach

## Complete Setup Procedure

### Step 1: Initial Setup and Authentication

#### 1Password CLI Setup
```bash
# Install 1Password CLI (if not already installed)
# On macOS
brew install 1password-cli

# On Linux
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | \
  sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
  sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo apt update && sudo apt install 1password-cli

# Authenticate with 1Password
op signin

# Verify authentication
op account list
```

#### Create Required 1Password Items
Create the following items in your 1Password vault (default vault name: "Personal"):

1. **GitHub** (Login item)
   - Field: `token` - Your GitHub personal access token

2. **OpenAI** (API Credentials item)
   - Field: `api_key` - Your OpenAI API key

3. **Database** (Database item)
   - Field: `password` - Database password

4. **SSH Key** (SSH Key item)
   - Field: `private_key` - SSH private key content

5. **WireGuard** (Password item)
   - Field: `private_key` - WireGuard private key

6. **Tailscale** (Password item)
   - Field: `auth_key` - Tailscale auth key

7. **Server API** (API Credentials item)
   - Field: `api_key` - Server API key
   - Field: `webhook_secret` - Webhook secret

### Step 2: Automated Secrets Retrieval

#### Run the Setup Script
```bash
# Make script executable (if not already)
chmod +x scripts/setup-1password-secrets.sh

# Run the automated setup
./scripts/setup-1password-secrets.sh
```

**What the script does:**
1. ✅ Verifies 1Password CLI installation and authentication
2. ✅ Checks vault accessibility
3. ✅ Retrieves all required secrets from 1Password
4. ✅ Generates `nixos/secrets/secrets.yaml` with retrieved secrets
5. ✅ Provides a summary of successfully retrieved secrets
6. ✅ Warns about security considerations

#### Expected Output
```
🔐 Setting up 1Password secrets integration...

✅ 1Password CLI is authenticated

📁 Using vault: Personal

🔑 Retrieving secrets from 1Password...

🔍 Retrieving GitHub (token)...
✅ Found GitHub
🔍 Retrieving OpenAI (api_key)...
✅ Found OpenAI
[... more retrievals ...]

🔄 Converting secrets to YAML format...

✅ Secrets retrieved and saved to: nixos/secrets/secrets.yaml

📋 Summary of retrieved secrets:
   - GitHub Token: ✅
   - OpenAI API Key: ✅
   - Database Password: ✅
   - SSH Private Key: ✅
   - WireGuard Key: ✅
   - Tailscale Key: ✅
   - Server API Key: ✅
   - Webhook Secret: ✅

⚠️  IMPORTANT SECURITY NOTES:
   - The secrets.yaml file contains sensitive information
   - Add it to .gitignore to prevent accidental commits
   - Consider encrypting it with SOPS for additional security

🎉 1Password secrets setup complete!
```

### Step 3: Verify .gitignore Configuration

Ensure the secrets file is properly excluded from version control:

```bash
# Check .gitignore contains secrets exclusion
grep -n "secrets" .gitignore

# If not present, add it
echo "# Secrets files" >> .gitignore
echo "nixos/secrets/secrets.yaml" >> .gitignore
echo "nixos/secrets/*.enc.yaml" >> .gitignore
```

### Step 4: Test NixOS Integration

#### Build and Test Configuration
```bash
# Test the configuration build
nixos-rebuild build --flake .#server

# If successful, deploy to server
nixos-rebuild switch --flake .#server
```

#### Verify Secrets Loading
```bash
# Check that secrets are properly loaded in NixOS
sudo nixos-option hb.secrets.github_token
sudo nixos-option hb.secrets.database.password
```

### Step 5: YubiKey Integration (Optional but Recommended)

For enhanced security, integrate YubiKey with your secrets management:

#### Test YubiKey Setup
```bash
# Run the YubiKey test script
./scripts/test-yubikey.sh
```

#### Configure YubiKey for 1Password
1. Add YubiKey as 2FA for your 1Password account
2. Store YubiKey PIN and recovery codes in 1Password
3. Use YubiKey for passwordless authentication where supported

## Current Implementation Status

✅ **Completed:**
- 1Password CLI installed on system
- Automated secrets retrieval script created (`scripts/setup-1password-secrets.sh`)
- Server configuration updated to remove SOPS dependency
- Secrets file added to `.gitignore` for security
- Documentation updated with new approach
- YubiKey integration documented and tested

🔄 **Next Steps:**
1. **Authenticate 1Password CLI** (ensure desktop app is running)
2. **Create/Update 1Password items** with required secret names
3. **Run the setup script** to retrieve secrets
4. **Test server deployment** with retrieved secrets
5. **Set up automated retrieval** for future deployments
6. **Configure YubiKey integration** for enhanced security

## Troubleshooting

### Common Issues and Solutions

#### 1Password CLI Issues

**"Not signed in to 1Password CLI"**
```bash
# Sign in to 1Password
op signin

# If using service account
export OP_SERVICE_ACCOUNT_TOKEN=your_token_here
```

**"Vault not found"**
```bash
# List available vaults
op vault list

# Update the vault name in the script
# Edit scripts/setup-1password-secrets.sh
# Change VAULT_NAME="Personal" to your actual vault name
```

**"Secret not found in vault"**
- Verify the item name in 1Password matches exactly
- Check field names match the expected format
- Ensure you're using the correct vault

#### NixOS Integration Issues

**"secrets.yaml not found"**
```bash
# Check if secrets directory exists
ls -la nixos/secrets/

# Run the setup script again
./scripts/setup-1password-secrets.sh
```

**"Secrets not loading in NixOS"**
```bash
# Check NixOS module syntax
nixos-option hb.secrets

# Verify secrets.yaml format
cat nixos/secrets/secrets.yaml
```

#### YubiKey Issues

**"YubiKey not detected"**
```bash
# Check USB connection
lsusb | grep -i yubico

# Restart PC/SC daemon
sudo systemctl restart pcscd

# Reload udev rules
sudo udevadm control --reload-rules
```

### Testing Your Setup

#### Automated Testing
```bash
# Test secrets retrieval
./scripts/setup-1password-secrets.sh

# Test YubiKey functionality
./scripts/test-yubikey.sh

# Test NixOS configuration
nixos-rebuild build --flake .#server
```

#### Manual Verification
```bash
# Verify 1Password CLI
op vault list
op item list --vault "Personal"

# Check secrets file
head -10 nixos/secrets/secrets.yaml

# Test NixOS secrets loading
sudo nixos-option hb.secrets.github_token
```

## Security Best Practices

### Secrets Management
1. **Never commit secrets** to version control
2. **Use strong, unique passwords** for all services
3. **Rotate secrets regularly** (at least annually)
4. **Limit secret access** to only necessary systems
5. **Monitor secret usage** and access logs

### 1Password Security
1. **Enable 2FA** on your 1Password account
2. **Use YubiKey** as hardware security key
3. **Set up emergency access** for account recovery
4. **Use strong master password** (20+ characters)
5. **Enable biometric unlock** where available

### YubiKey Security
1. **Set strong PIN** (8+ characters, mixed case)
2. **Keep firmware updated**
3. **Have backup YubiKey** ready
4. **Store recovery information** securely
5. **Only enable necessary interfaces**

### Operational Security
1. **Regular backups** of your 1Password vault
2. **Test recovery procedures** quarterly
3. **Document all procedures** and keep updated
4. **Train team members** on security procedures
5. **Conduct security audits** regularly

## Maintenance Procedures

### Regular Maintenance
1. **Monthly**: Review and rotate expired secrets
2. **Quarterly**: Test backup recovery procedures
3. **Annually**: Complete security audit and secret rotation
4. **As needed**: Update software and firmware

### Emergency Procedures
1. **Lost YubiKey**: Use backup YubiKey or recovery codes
2. **Compromised secret**: Immediately rotate the affected secret
3. **Account breach**: Follow 1Password's account recovery process
4. **System compromise**: Rotate all secrets and rebuild systems

## Next Steps

1. **Choose your tool** based on your needs
2. **Set up authentication** (service accounts for CI/CD)
3. **Create your secrets vault/structure**
4. **Test retrieval** in your development environment
5. **Integrate with NixOS** using the examples above
6. **Implement security best practices**
7. **Set up monitoring and maintenance procedures**

Would you like me to help you set up either 1Password or Bitwarden CLI integration?</content>
</xai:function_call">Create comprehensive secrets management guide