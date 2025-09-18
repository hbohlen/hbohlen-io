{ config, pkgs, ... }:

{
  # Import shared modules
  imports = [
    ../../modules/common.nix
    ../../modules/users.nix
    ../../modules/packages.nix
  ];

  # Bootloader - hardware-specific kernel parameters
  boot = {
    # Kernel parameters for ASUS Zephyrus M16 hardware
    kernelParams = [
      "quiet"
      "splash"
      "i915.enable_dpcd_backlight=1"
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
    ];
  };

  # Host-specific settings
  networking.hostName = "laptop";

  # User account - add laptop-specific groups
  users.users.hbohlen.extraGroups = [ "libvirtd" ];

  # ASUS-specific services and hardware
  services = {
    asusd.enable = true;
    asusd.enableUserService = true;
    supergfxd.enable = true;

  };
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  # ASUS hardware-specific configuration
  hardware.asus.battery.chargeUpto = 80; # Set battery charge limit

  # Podman container engine (laptop-specific)
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
}