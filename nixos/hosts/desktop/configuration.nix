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
    # Kernel parameters for MSI Z590 + Intel graphics
    kernelParams = [
      "quiet"
      "splash"
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
  };

  # Desktop-specific services
  services = {
    # ASUS services (for ASUS motherboard compatibility)
    asusd.enable = true;

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