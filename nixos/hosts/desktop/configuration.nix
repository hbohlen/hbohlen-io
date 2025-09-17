{ config, pkgs, ... }:

{
  # Bootloader, Kernel, and Hardware Tweaks
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

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

  # Networking - MSI Z590 has multiple network interfaces
  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
  };

  # Timezone and locale
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # User Account
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Hayden";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
  };

  # Allow unfree packages for NVIDIA drivers
  nixpkgs.config.allowUnfree = true;

  # Hardware Configuration
  hardware = {
    enableRedistributableFirmware = true;

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

  # Essential Services and Daemons
  services = {
    # Display Manager and Desktop
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Configure NVIDIA as primary GPU
      videoDrivers = [ "nvidia" ];
    };

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

  # Virtualization
  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    vim
    htop
    btop
    fastfetch
    gnome-tweaks
    pciutils
    usbutils
  ];

  # Enable modern Nix features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Security
  security = {
    rtkit.enable = true; # For Pipewire
    polkit.enable = true;
  };

  system.stateVersion = "24.05";
}