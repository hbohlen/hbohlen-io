{ config, pkgs, ... }:

{
  # Import shared modules
  imports = [
    ../../modules/common.nix
    ../../modules/users.nix
    ../../modules/packages.nix
  ];

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

  # Host-specific networking
  networking.hostName = "desktop";

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

    # Enable graphics
    graphics.enable = true;
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

    # Disable PulseAudio (using Pipewire instead)
    pulseaudio.enable = false;

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
    podman = {
      enable = true;
      dockerCompat = true;  # Enable Docker API compatibility
      dockerSocket.enable = true;
    };
  };
}