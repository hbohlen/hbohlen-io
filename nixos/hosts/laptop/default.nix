{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Host-specific settings
  networking.hostName = "laptop";

  # Bootloader - hardware-specific kernel parameters
  boot = {
    # Kernel parameters for ASUS Zephyrus M16 hardware
    kernelParams = [
      "quiet"
      "splash"
      "i915.enable_dpcd_backlight=1"
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
    ];
  };

  # User account - add laptop-specific groups
  users.users.hbohlen.extraGroups = [ "libvirtd" ];

  # ASUS-specific services and hardware
  services = {
    asusd.enable = true;
    asusd.enableUserService = true;
    supergfxd.enable = true;
  };
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  # ASUS hardware-specific configuration
  hardware.asus.battery.chargeUpto = 80; # Set battery charge limit

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
      "/var/lib/nixos"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    users.hbohlen = {
      directories = [
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        ".config"
        ".local"
        ".ssh"
        ".gnupg"
        ".cache"
        ".steam"
        ".var"
      ];
    };
  };
}