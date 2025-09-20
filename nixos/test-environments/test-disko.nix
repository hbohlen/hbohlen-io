# Test disko configuration for QEMU VM
# Uses /dev/vda (virtual disk) instead of physical device

{ config, lib, pkgs, ... }:

{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda";  # QEMU virtual disk
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "20G";  # Smaller for testing
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            persist = {
              size = "100%";  # Use remaining space
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/persist";
              };
            };
          };
        };
      };
    };
  };
}