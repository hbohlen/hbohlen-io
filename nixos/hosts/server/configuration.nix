{ config, pkgs, ... }:

{
  # Import shared modules
  imports = [
    ../../modules/users.nix
    ../../modules/packages.nix
  ];

  # Import sops-nix for secrets management
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets = {
    github_token = {};
    openai_api_key = {};
    database_password = {
      sopsFile = ../../secrets/secrets.yaml;
      path = "database.password";
    };
    ssh_private_key = {
      mode = "0600";
      owner = config.users.users.hbohlen.name;
    };
    wireguard_private_key = {};
    tailscale_auth_key = {};
  };

  # Bootloader - server-specific
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Host-specific settings
  networking.hostName = "server";

  # User account - add server-specific groups
  users.users.hbohlen.extraGroups = [ ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable modern Nix features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Essential server services
  services = {
    # SSH for remote access
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # Basic networking
    networkmanager.enable = true;
  };

  # Server-specific packages
  environment.systemPackages = with pkgs; [
    # System utilities (in addition to common packages)
    htop
    curl
    wget
    git
    vim
    tmux
    rsync
    ncdu
    tree
    jq
    ripgrep
    fd
  ];

  # Security
  security = {
    sudo.enable = true;
  };

  # System state version
  system.stateVersion = "24.05";
}