{ config, pkgs, ... }:

{
  # Bootloader, Kernel, and Hardware Tweaks
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Kernel parameters for ASUS Zephyrus M16 hardware
    kernelParams = [
      "quiet"
      "splash"
      "i915.enable_dpcd_backlight=1"
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
    ];
  };

  # User Account and System Info
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Hayden";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };
  networking.hostName = "laptop";

  # Allow unfree packages for NVIDIA drivers
  nixpkgs.config.allowUnfree = true;

  # Essential Services and Daemons for ASUS hardware
  services = {
    asusd.enable = true;
    asusd.enableUserService = true;
    supergfxd.enable = true;

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  # Essential Hardware Configuration
  hardware.enableRedistributableFirmware = true; # For the Intel Wi-Fi card
  hardware.asus.battery.chargeUpto = 80; # Set battery charge limit

  # Podman container engine
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    git
    wget
    btop
    fastfetch
    gnome-tweaks
    vim
  ];

  # Enable modern Nix features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";
}