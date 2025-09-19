# Common system services
{ config, pkgs, ... }:

{
  services = {
    # Enable Flatpak for additional applications
    flatpak.enable = true;
    
    # Enable Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    
    # Enable CUPS for printing
    printing.enable = true;
    
    # Enable Avahi for network discovery
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    
    # Enable GNOME keyring for credential storage
    gnome.gnome-keyring.enable = true;
    
    # Enable system tray
    xserver.libinput.enable = true;
    
    # Enable location services
    geoclue2.enable = true;
    
    # Enable UPnP for network device discovery
    upower.enable = true;
    
    # Enable system monitoring
    sysstat.enable = true;
    
    # Enable early OOM killer
    earlyoom.enable = true;
    
    # Enable fstrim for SSD optimization
    fstrim.enable = true;
    
    # Enable periodic system cleanup
    logrotate.enable = true;
    
    # Enable automatic system updates
    auto-cpufreq.enable = true;
    
    # Enable thermald for thermal management
    thermald.enable = true;
    
    # Enable Tailscale for mesh networking
    tailscale.enable = true;
    
    # Enable firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
      allowedUDPPorts = [ ];
    };
  };
  
  # Enable virtualization
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf.enable = true;
      };
    };
    docker = {
      enable = false; # Using podman instead
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  
  # Enable programs
  programs = {
    # Enable dconf for GNOME settings
    dconf.enable = true;
    
    # Enable seahorse for password management
    seahorse.enable = true;
    
    # Enable file manager extensions
    gnome-file-roller.enable = true;
    
    # Enable archive tools
    archive-tools.enable = true;
    
    # Enable appimage support
    appimage = {
      enable = true;
      binfmt = true;
    };
    
    # Enable steam for gaming
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    
    # Enable gaming tools
    gamemode.enable = true;
    
    # Enable Android development tools
    adb.enable = true;
    
    # Enable k3b for CD/DVD burning
    k3b.enable = true;
    
    # Enable Wireshark for network analysis
    wireshark.enable = true;
    
    # Enable virt-manager for VM management
    virt-manager.enable = true;
  };
  
  # Enable hardware acceleration
  hardware = {
    # Enable OpenGL
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    
    # Enable OpenCL
    opencl.enable = true;
    
    # Enable CPU microcode updates
    cpu = {
      amd.updateMicrocode = true;
      intel.updateMicrocode = true;
    };
    
    # Enable sensor monitoring
    sensor.iio.enable = true;
    
    # Enable Bluetooth
    bluetooth.enable = true;
  };
}