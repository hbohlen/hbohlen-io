# Common system packages
{ config, pkgs, ... }:

{
  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Development tools
    git
    vim
    neovim
    vscode

    # System utilities
    wget
    curl
    htop
    btop
    fastfetch
    pciutils
    usbutils

    # Desktop utilities

    # Container tools
    podman-compose
    podman-desktop

    # Web browsers
    vivaldi

    # Password managers
    _1password-gui

    # Development environments
    devbox # Development environment tool

    # Note taking and productivity
    affine # Affine Pro note taking app

  ];
}