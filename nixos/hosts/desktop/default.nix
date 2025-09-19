{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Host-specific networking
  networking.hostName = "desktop";

  # Bootloader - hardware-specific kernel parameters and modules
  boot = {
    # Kernel parameters for MSI Z590 + NVIDIA graphics
    kernelParams = [
      "quiet"
      "splash"
      # NVIDIA specific parameters for better multi-monitor support
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
      "nvidia_drm.modeset=1"
    ];

    extraModulePackages = [ ];
  };

  # User account - add desktop-specific groups
  users.users.hbohlen.extraGroups = [ "libvirtd" ];

  # Hardware Configuration - desktop-specific
  hardware = {
    # CPU microcode updates
    cpu.intel.updateMicrocode = true;

    # NVIDIA Graphics
    nvidia = {
      # Enable NVIDIA drivers
      modesetting.enable = true;

      # Enable NVIDIA power management
      powerManagement.enable = true;

      # Enable NVIDIA power management for mobile GPUs
      powerManagement.finegrained = false;

      # Use open source kernel module (recommended)
      open = false;

      # Enable NVIDIA settings
      nvidiaSettings = true;

      # Package to use (latest is usually best)
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    
  };

  # Desktop-specific services
  services = {
    # ASUS services (for ASUS motherboard compatibility)
    asusd.enable = true;
    asusd.enableUserService = true;

    # Pipewire for audio (desktop-specific audio setup)
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    

    # X11 configuration for NVIDIA
    xserver = {
      # Enable X11
      enable = true;

      # Configure X11 for NVIDIA
      videoDrivers = [ "nvidia" ];

      # Display manager and desktop are configured in common.nix
    };
  };

  # Virtualization - desktop-specific
  virtualisation = {
    libvirtd.enable = true;
  };

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
      "/var/lib/libvirt"
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