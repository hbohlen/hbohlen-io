{ config, pkgs, ... }:

{
  # Import shared modules
  imports = [
    ../../modules/common.nix
    ../../modules/users.nix
    ../../modules/packages.nix
  ];

  # Secrets are managed via 1Password CLI
  # Run scripts/setup-1password-secrets.sh to retrieve secrets

  # Host-specific settings
  networking.hostName = "server";

  # User account - add server-specific groups
  users.users.hbohlen.extraGroups = [ ];

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

    # Disable GUI services for server
    xserver.enable = false;
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;
  };

  # Server-specific packages (minimal)
  environment.systemPackages = with pkgs; [
    # Server-specific utilities (in addition to common packages)
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
}