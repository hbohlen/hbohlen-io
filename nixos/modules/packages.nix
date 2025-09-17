# Common system packages
{ config, pkgs, ... }:

{
  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Development tools
    git
    vim

    # System utilities
    wget
    curl
    htop
    btop
    fastfetch
    pciutils
    usbutils

    # Desktop utilities
    gnome-tweaks

    # YubiKey support
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    pam_yubico
    yubikey-agent
    libyubikey
    yubikey-manager-qt
  ];
}