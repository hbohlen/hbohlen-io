# Common configuration shared between all hosts
{ config, pkgs, ... }:

{
  # Bootloader - basic setup (hardware-specific params handled in host configs)
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Timezone and locale
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable modern Nix features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Hardware - basic settings
  hardware.enableRedistributableFirmware = true;

  # Essential Services
  services = {
    # Display Manager and Desktop
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  # Network Manager
  networking.networkmanager.enable = true;

  # Security
  security = {
    rtkit.enable = true; # For Pipewire
    polkit.enable = true;
  };

  # System state version
  system.stateVersion = "24.05";
}