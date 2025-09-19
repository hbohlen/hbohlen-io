# Task List for AI Implementation

### Phase 1: Foundational Refactoring

1. **Update flake.nix to modern structure**
   * Add required inputs: **impermanence**, **opnix**, **hyprland**
   * Ensure proper **follows** patterns
   * Pin to stable nixos-24.05 branch
   * Add devShells output
2. **Reorganize directory structure**
   * Create **/hosts/\<hostname>/default.nix** files
   * Move hardware configurations to **/hosts/\<hostname>/hardware-configuration.nix**
   * Create **/modules/system/** for shared system modules
   * Create **/modules/user/** for shared user modules
   * Set up **/secrets/** directory
3. **Remove sops-nix artifacts**
   * Delete **secrets.nix** module
   * Remove any sops-nix references
   * Clean up encrypted secret files



### Phase 2: 1Password Integration

1. **Create 1Password NixOS module**
   * Implement **modules/1password.nix**
   * Configure 1Password GUI and CLI
   * Set up PolKit integration
   * Add custom browser support
2. **Create 1Password Home Manager module**
   * Implement **users/hbohlen/modules/1password.nix**
   * Add shell helper functions
   * Configure Git with 1Password SSH integration
   * Set up SSH configuration
3. **Set up 1Password vault structure**
   * Create Production vault
   * Create Infrastructure vault
   * Organize secrets by service/environment
   * Generate service account token



### Phase 3: Tailscale Implementation

1. **Create Tailscale module**
   * Implement **modules/tailscale.nix**
   * Configure automatic connection service
   * Add device tagging helper script
   * Set up firewall rules
2. **Configure ACL policy**
   * Create admin and family groups
   * Set up tag ownership
   * Define access rules
   * Configure SSH access
3. **Set up DNS records**
   * Enable MagicDNS
   * Configure Cloudflare CNAME records
   * Point to Tailscale .ts.net addresses



### Phase 4: Caddy Reverse Proxy

1. **Create custom Caddy package**
   * Implement **overlays/caddy-cloudflare.nix**
   * Add Cloudflare DNS plugin
   * Set up build configuration
2. **Configure Caddy service**
   * Implement **modules/caddy.nix**
   * Set up virtual hosts
   * Configure TLS with Cloudflare
   * Add security headers
3. **Create secrets loading service**
   * Set up systemd service for 1Password integration
   * Configure environment file management
   * Set proper permissions



### Phase 5: Podman & TSDProxy

1. **Enhance Podman configuration**
   * Update **modules/podman.nix**
   * Configure storage optimization
   * Set up networking
   * Add helper tools
2. **Configure TSDProxy**
   * Create **/config/tsdproxy/tsdproxy.yaml**
   * Set up Podman socket connection
   * Configure Tailscale providers
   * Create service definitions
3. **Create container compose files**
   * Set up example stack
   * Configure TSDProxy labels
   * Create persistent volumes
   * Set up networking



### Phase 6: Impermanence Implementation

1. **Configure filesystem**
   * Update hardware configuration files
   * Set up tmpfs for root
   * Configure persistent storage
2. **Declare persistence**
   * Set up environment.persistence
   * Define directories to persist
   * Define files to persist



### Phase 7: Home Manager Enhancement

1. **Update user configuration**
   * Create **users/hbohlen/modules/programming.nix**
   * Add development tools
   * Configure shell aliases
   * Set up helper functions
2. **Enhance shell configuration**
   * Update zsh configuration
   * Add custom functions
   * Configure prompt
   * Set up completions



### Phase 8: Final Integration

1. **Update host configurations**
   * Import new modules
   * Configure per-host settings
   * Set up user management
2. **Create documentation**
   * Update README.md
   * Document new architecture
   * Provide usage examples
   * Add troubleshooting guide
3. **Test and validate**
   * Build configuration
   * Test all services
   * Validate secrets management
   * Test container functionality



## Implementation Notes

### Security Considerations

* Never commit 1Password tokens to version control
* Use service accounts with minimal required permissions
* Regularly rotate secrets and tokens
* Enable firewall restrictions



### Performance Optimizations

* Enable Nix store optimization
* Configure automatic garbage collection
* Use tmpfs for ephemeral storage
* Optimize container storage



### Maintenance Guidelines

* Regularly update flake inputs
* Monitor system performance
* Backup persistent data
* Document any custom configurations
