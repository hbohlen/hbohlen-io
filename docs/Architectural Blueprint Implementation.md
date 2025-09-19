# Architectural Blueprint Implementation

### Core Principles

#### 1. Absolute Reproducibility

* Pin all dependencies using Nix Flakes
* Ensure bit-for-bit reproducible builds
* Transactional upgrades with rollback capability



#### 2. Radical Modularity

* Separate system-wide settings, user configurations, hardware profiles, and secrets
* Reusable modules across different machines
* Clear separation of concerns



#### 3. Stateless by Design (Impermanence)

* Ephemeral root filesystem (tmpfs)
* Explicit persistence declaration
* Enhanced security through statelessness



#### 4. Secure by Default

* 1Password integration for secrets management
* Declarative security configurations
* Hardened service configurations

## Enhanced Migration Plan

### 1. 1Password Integration & Secrets Management

#### NixOS Module Configuration

```nix
# modules/1password.nix
{ config, lib, pkgs, ... }:

{
  # Enable 1Password with proper NixOS integration
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "hbohlen" ];
  };

  # Allow unfree packages for 1Password
  nixpkgs.config.allowUnfreePredicate = pkg: 
    builtins.elem (lib.getName pkg) [ "1password-gui" "1password" ];

  # Custom browser support
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      vivaldi-bin
      brave-browser
    '';
    mode = "0755";
  };
}
```

#### Home Manager Integration

```nix
# users/hbohlen/modules/1password.nix
{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ _1password-cli ];

  # Shell integration for 1Password CLI
  programs.zsh.initExtra = ''
    # 1Password CLI helper functions
    function op-get() {
      op read "$1"
    }
    
    function op-export() {
      local secret_ref="$1"
      local var_name="$2"
      if [ -z "$var_name" ]; then
        var_name="$(echo "$secret_ref" | sed 's/.*\/\([^/]*\)$/\1/' | tr '[:lower:]' '[:upper:]')"
      fi
      export "$var_name"="$(op read "$secret_ref")"
      echo "Exported $var_name from 1Password"
    }

    # Load project secrets from .env.1password
    function load-op-env() {
      if [ -f ".env.1password" ]; then
        echo "Loading secrets from .env.1password..."
        while IFS= read -r line || [ -n "$line" ]; do
          if [[ "$line" =~ ^[A-Z_]+=op:// ]]; then
            local var_name="$(echo "$line" | cut -d'=' -f1)"
            local secret_ref="$(echo "$line" | cut -d'=' -f2-)"
            export "$var_name"="$(op read "$secret_ref")"
            echo "Loaded $var_name"
          fi
        done < ".env.1password"
      fi
    }
  '';

  # Git configuration with 1Password integration
  programs.git = {
    enable = true;
    userName = "Hayden Bohlen";
    userEmail = "hbohlen@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      # 1Password SSH key integration
      gpg.format = "ssh";
      user.signingkey = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };

  # SSH configuration for 1Password
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
        AddKeysToAgent yes
        UseKeychain yes
    '';
  };
}
```

#### 1Password Vault Structure

```
Production/
├── tailscale-main/
│   ├── auth-key (reusable auth key)
│   └── oauth-client-secret
├── cloudflare-dns/
│   ├── api-token (DNS management)
│   └── zone-id
├── caddy-certs/
│   └── cf-api-token
└── falkordb-prod/
    ├── admin-password
    └── connection-string

Infrastructure/
├── ssh-keys/
│   ├── server-key
│   └── backup-key
└── tailscale-authkeys/
    ├── tsdproxy-main
    └── tsdproxy-restricted
```

### 2. Tailscale Configuration

```nix
# modules/tailscale.nix
{ config, lib, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
    permitCertUid = "caddy";
  };

  # Tailscale automatic connection service
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = "/etc/tailscale/auth.env";
    };
    script = with pkgs; ''
      sleep 2
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ "$status" = "Running" ]; then
        echo "Tailscale already connected"
        exit 0
      fi
      
      # Read auth key from 1Password or environment
      if command -v op >/dev/null 2>&1 && op account get >/dev/null 2>&1; then
        AUTH_KEY="$(op read 'op://Infrastructure/tailscale-main/auth-key')"
      else
        AUTH_KEY="$TS_AUTHKEY"
      fi
      
      ${tailscale}/bin/tailscale up --authkey="$AUTH_KEY" --accept-routes
    '';
  };

  # Helper script for device tagging
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "tailscale-tag" ''
      #!/usr/bin/env bash
      set -euo pipefail
      
      if [ $# -eq 0 ]; then
        echo "Usage: tailscale-tag <tag1,tag2,...>"
        echo "Example: tailscale-tag tag:server,tag:prod"
        exit 1
      fi
      
      echo "Applying tags: $1"
      sudo tailscale up --advertise-tags="$1"
    '')
  ];

  # Firewall configuration
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    interfaces.tailscale0.allowedTCPPorts = [ 80 443 ];
  };
}
```

#### ACL Policy

```json
{
  "groups": {
    "group:admin": ["autogroup:owner"],
    "group:family": ["autogroup:owner"]
  },
  "tagOwners": {
    "tag:server": ["group:admin"],
    "tag:desktop": ["group:admin"], 
    "tag:laptop": ["group:admin"],
    "tag:container": ["group:admin"],
    "tag:prod": ["group:admin"],
    "tag:dev": ["group:admin"]
  },
  "ACLs": [
    {
      "action": "accept",
      "src": ["autogroup:owner"],
      "dst": ["autogroup:self:*"]
    },
    {
      "action": "accept", 
      "src": ["group:admin"],
      "dst": ["tag:server:22,80,443,8080-8090"]
    },
    {
      "action": "accept",
      "src": ["group:family"],
      "dst": ["tag:container:80,443,3000-9000"]
    },
    {
      "action": "accept",
      "src": ["autogroup:owner"],
      "dst": ["tag:desktop:3389,5900"]
    }
  ],
  "ssh": [
    {
      "action": "accept",
      "src": ["autogroup:owner"],
      "dst": ["tag:server"],
      "users": ["hbohlen", "root"]
    }
  ]
}
```

### 3. Caddy Reverse Proxy with Tailscale

#### Custom Caddy Package with Cloudflare Plugin

```nix
# overlays/caddy-cloudflare.nix
final: prev:

let
  plugins = [ "github.com/caddy-dns/cloudflare" ];
  goImports = prev.lib.flip prev.lib.concatMapStrings plugins (pkg: "  _ \"${pkg}\"\n");
  goGets = prev.lib.flip prev.lib.concatMapStrings plugins (pkg: "go get ${pkg}\n");
  
  main = ''
    package main
    
    import (
      caddycmd "github.com/caddyserver/caddy/v2/cmd"
      _ "github.com/caddyserver/caddy/v2/modules/standard"
    ${goImports})
    
    func main() {
      caddycmd.Main()
    }
  '';
in
{
  caddy-cloudflare = prev.buildGo121Module {
    pname = "caddy-cloudflare";
    version = prev.caddy.version;
    runVend = true;
    subPackages = [ "cmd/caddy" ];
    src = prev.caddy.src;
    vendorHash = "sha256-your-vendor-hash-here";
    
    overrideModAttrs = (_: {
      preBuild = ''
        echo '${main}' > cmd/caddy/main.go
        ${goGets}
      '';
      postInstall = "cp go.sum go.mod $out/";
    });
    
    postPatch = ''
      echo '${main}' > cmd/caddy/main.go
    '';
  };
}
```

#### Caddy Service Configuration

```nix
# modules/caddy.nix
{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy-cloudflare;
    
    globalConfig = ''
      servers {
        protocols h1 h2 h3
      }
      auto_https disable_redirects
    '';
    
    environmentFile = "/run/caddy/environment";
    
    virtualHosts = {
      "falkordb.hbohlen.io" = {
        extraConfig = ''
          bind tailscale0
          reverse_proxy 127.0.0.1:8080
          
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
          
          header {
            Strict-Transport-Security "max-age=31536000; includeSubDomains"
            X-Frame-Options "DENY"
            X-Content-Type-Options "nosniff"
            Referrer-Policy "strict-origin-when-cross-origin"
          }
        '';
      };
      
      "portainer.hbohlen.io" = {
        extraConfig = ''
          bind tailscale0
          reverse_proxy 127.0.0.1:9000
          
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
        '';
      };
    };
  };

  # Systemd service to populate Caddy environment from 1Password
  systemd.services.caddy-secrets = {
    description = "Load Caddy secrets from 1Password";
    before = [ "caddy.service" ];
    wantedBy = [ "caddy.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
    };
    script = ''
      mkdir -p /run/caddy
      
      # Load Cloudflare API token from 1Password
      if command -v op >/dev/null 2>&1 && op account get >/dev/null 2>&1; then
        echo "CLOUDFLARE_API_TOKEN=$(op read 'op://Production/cloudflare-dns/api-token')" > /run/caddy/environment
      else
        echo "Warning: 1Password CLI not available or not authenticated"
        touch /run/caddy/environment
      fi
      
      chmod 600 /run/caddy/environment
      chown caddy:caddy /run/caddy/environment
    '';
  };
}
```

### 4. Podman & TSDProxy Configuration

#### Enhanced Podman Module

```nix
# modules/podman.nix  
{ config, lib, pkgs, ... }:

{
  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "podman";
    
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      autoPrune.enable = true;
      
      # Enhanced networking
      defaultNetwork.settings = {
        dns_enabled = true;
        ipv6_enabled = false;
      };
      
      # Rootless configuration improvements
      extraPackages = with pkgs; [ 
        fuse-overlayfs 
        passt
      ];
    };
    
    # Container storage optimization
    containers.storage.settings = {
      storage = {
        driver = "btrfs";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        options.overlay.mountopt = "nodev,metacopy=on";
      };
    };
  };

  # Rootless container support
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 80;
    "kernel.unprivileged_userns_clone" = 1;
  };

  # Environment packages
  environment.systemPackages = with pkgs; [
    podman-compose
    podman-tui
    podman-desktop
    dive
    lazydocker
    
    # TSDProxy setup script
    (writeShellScriptBin "setup-tsdproxy" ''
      #!/usr/bin/env bash
      set -euo pipefail
      
      echo "Setting up TSDProxy configuration..."
      
      # Create directories
      sudo mkdir -p /config/tsdproxy /data/tsdproxy /config/secrets
      sudo chmod 755 /config/tsdproxy /data/tsdproxy
      sudo chmod 700 /config/secrets
      
      # Get Tailscale auth keys from 1Password
      if command -v op >/dev/null 2>&1 && op account get >/dev/null 2>&1; then
        echo "Fetching Tailscale auth keys from 1Password..."
        op read "op://Infrastructure/tailscale-authkeys/tsdproxy-main" | sudo tee /config/secrets/authkey > /dev/null
        op read "op://Infrastructure/tailscale-authkeys/tsdproxy-restricted" | sudo tee /config/secrets/restricted_authkey > /dev/null
      else
        echo "Warning: 1Password CLI not available. Please manually create auth key files."
        exit 1
      fi
      
      sudo chmod 600 /config/secrets/*
      
      echo "TSDProxy setup complete. You can now start containers with TSDProxy labels."
    '')
  ];
}
```

#### TSDProxy Configuration

```yaml
# /config/tsdproxy/tsdproxy.yaml
defaultProxyProvider: default

podman:
  local:
    host: unix:///run/podman/podman.sock
    targetHostname: 100.x.y.z # Your Tailscale IP
    defaultProxyProvider: default

tailscale:
  providers:
    default:
      authKeyFile: /config/secrets/authkey
      controlUrl: https://controlplane.tailscale.com
      
    restricted:
      authKeyFile: /config/secrets/restricted_authkey
      controlUrl: https://controlplane.tailscale.com
      
  dataDir: /data/tsdproxy

files:
  services:
    filename: /config/services.yaml
    defaultProxyProvider: default

http:
  hostname: 0.0.0.0
  port: 8080

log:
  level: info
  json: false

proxyAccessLog: true
```

#### Podman Compose Example

```yaml
# ~/containers/example-stack/compose.yaml
version: '3.8'

services:
  tsdproxy:
    image: ghcr.io/almeidapaulopt/tsdproxy:latest
    container_name: tsdproxy
    restart: unless-stopped
    volumes:
      - /run/podman/podman.sock:/var/run/docker.sock:rw
      - /config/tsdproxy:/config:rw
      - /data/tsdproxy:/data:rw
    ports:
      - "8080:8080"
    networks:
      - tsdproxy

  falkordb:
    image: falkordb/falkordb:latest
    container_name: falkordb
    restart: unless-stopped
    volumes:
      - falkordb_data:/data
    environment:
      - REDIS_ARGS=--save 60 1 --loglevel warning
    labels:
      - "tsdproxy.enable=true"
      - "tsdproxy.name=falkordb"
      - "tsdproxy.container_port=6379"
      - "tsdproxy.provider=default"
      - "tsdproxy.ephemeral=false"
    networks:
      - tsdproxy

volumes:
  falkordb_data:

networks:
  tsdproxy:
    driver: bridge
```

### 5. Impermanence Implementation

#### Filesystem Configuration

```nix
# /hosts/<hostname>/hardware-configuration.nix
{ ... }:
{
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=4G" "mode=755" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/your-nix-partition-uuid";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/your-boot-partition-uuid";
    fsType = "vfat";
  };
}
```

#### Persistence Declaration

```nix
# /hosts/<hostname>/default.nix
{ ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    # ... other imports
  ];

  # Define which parts of the filesystem should persist
  environment.persistence."/persist/system" = {
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
```

## Home Manager Enhancements

### Comprehensive Development Environment

```nix
# users/hbohlen/modules/programming.nix
{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core development tools
    git
    gh
    lazygit
    
    # Languages and runtimes
    go
    rustup
    nodejs
    bun
    deno
    python311
    python311Packages.pip
    python311Packages.poetry
    
    # Shell and system utilities
    ripgrep
    fd
    bat
    eza
    zoxide
    fzf
    tldr
    btop
    htop
    ncdu
    tree
    jq
    yq
    
    # Network and container tools
    curlie
    httpie
    dive
    lazydocker
    
    # Text editors and IDEs
    helix
    neovim
    vscode
    zed-editor
    
    # Development environment management
    direnv
    nix-direnv
    devenv
    
    # File management
    ranger
    mc
    
    # Compression and archive tools
    unzip
    p7zip
    
    # Modern replacements
    delta
    difftastic
    dust
    procs
  ];

  # Enhanced shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      # File operations
      ll = "eza -la --git";
      la = "eza -a";
      lt = "eza -la --tree --level=2";
      ".." = "cd ..";
      "..." = "cd ../..";
      
      # Git aliases
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      
      # NixOS aliases
      nrs = "sudo nixos-rebuild switch --flake ~/system-configs";
      nrt = "sudo nixos-rebuild test --flake ~/system-configs";
      nrb = "sudo nixos-rebuild boot --flake ~/system-configs";
      hms = "home-manager switch --flake ~/system-configs";
      
      # Container aliases
      pc = "podman-compose";
      pd = "podman";
      pps = "podman ps";
      pls = "podman images";
      
      # Network tools
      myip = "curl -s https://ipinfo.io/ip";
      localip = "ip route get 1 | head -1 | cut -d' ' -f7";
      
      # 1Password shortcuts
      opl = "op item list";
      opg = "op item get";
    };
    
    initExtra = ''
      # Enhanced rebuild function
      rebuild() {
        local host="${1:-$(hostname)}"
        local action="${2:-switch}"
        local flake_path="$HOME/system-configs"
        
        case "$host" in
          laptop|desktop|server)
            echo "🔄 Rebuilding $host with action: $action"
            if [[ "$action" == "switch" || "$action" == "boot" ]]; then
              sudo nixos-rebuild "$action" --flake "$flake_path#$host"
            else
              nixos-rebuild "$action" --flake "$flake_path#$host"
            fi
            ;;
          *)
            echo "❌ Unknown host: $host"
            echo "Available hosts: laptop, desktop, server"
            return 1
            ;;
        esac
      }
    '';
  };
}
```
