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
    
    # Printing support
    printing.enable = true;
    
    # Sound with pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    
    # Disable pulseaudio since we use pipewire
  };
  
  # Hardware configuration
  hardware.pulseaudio.enable = false;

  # Network Manager
  networking.networkmanager.enable = true;

  # Security
  security = {
    rtkit.enable = true; # For Pipewire
    polkit.enable = true;
    sudo.enable = true;
    sudo.wheelNeedsPassword = true;
  };

  # Users
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Hayden Bohlen";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
  };

  # Basic packages for all systems
  environment.systemPackages = with pkgs; [
    # Basic utilities
    git
    curl
    wget
    vim
    htop
    btop
    tree
    ripgrep
    fd
    bat
    eza
    jq
    yq
    
    # Shell
    zsh
    starship
    
    # Network tools
    networkmanager-applet
  ];

  # System state version
  system.stateVersion = "24.05";
}