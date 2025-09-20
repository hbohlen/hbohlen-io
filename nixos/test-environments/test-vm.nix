# Test VM configuration for testing NixOS setup with QEMU
# This allows testing disko partitioning and impermanence in a virtual environment

{ config, pkgs, ... }:

{
  imports = [
    # Import the desktop configuration for testing
    ../hosts/desktop/default.nix
    # Override disko for VM
    ./test-disko.nix
  ];

  # VM-specific settings
  networking.hostName = "test-vm";

  # QEMU virtualisation settings
  virtualisation = {
    qemu = {
      options = [
        "-enable-kvm"
        "-cpu host"
        "-m 4096"
        "-smp 4"
        "-drive file=test-disk.img,if=virtio,format=raw"
        "-net nic,model=virtio"
        "-net user"
      ];
    };
  };

  # Disable some desktop services for VM testing
  services.xserver.enable = false;
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  # Add some test packages
  environment.systemPackages = with pkgs; [
    qemu
    disko
  ];

  # System state version
  system.stateVersion = "24.05";
}