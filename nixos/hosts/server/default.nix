{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Host-specific settings
  networking.hostName = "server";

  # Bootloader - server-specific
  boot = {
    kernelPackages = pkgs.linuxPackages;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

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
  };

  # Basic networking
  networking.networkmanager.enable = true;

  # Persistence configuration for impermanence
  environment.persistence."/persist/system" = {
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager"
      "/etc/NetworkManager/system-connections"
      "/var/lib/systemd/coredump"
      "/var/lib/containers"
      "/var/lib/caddy"
      "/var/lib/tailscale"
      "/var/lib/acme"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}