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
    # Kernel parameters for MSI Z590 + NVIDIA + Intel graphics
    kernelParams = [
      "quiet"
      "splash"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    ];

    # Enable NVIDIA modesetting
    kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    extraModulePackages = [ ];
  };

  # Host-specific networking
  networking.hostName = "desktop";

  # User account - add desktop-specific groups
  users.users.hbohlen.extraGroups = [ "libvirtd" ];

  # Hardware Configuration - desktop-specific
  hardware = {
    # NVIDIA Graphics Configuration
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # CPU microcode updates
    cpu.intel.updateMicrocode = true;
  };

  # Desktop-specific services
  services = {
    # ASUS services (for ASUS motherboard compatibility)
    asusd.enable = true;

    # Graphics switching daemon for NVIDIA
    supergfxd.enable = true;

    # Configure NVIDIA as primary GPU
    xserver.videoDrivers = [ "nvidia" ];

    # Pipewire for audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Disable PulseAudio (using Pipewire instead)
    pulseaudio.enable = false;
  };

  # Path for supergfxd
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

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