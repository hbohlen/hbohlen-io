# nixos/hosts/laptop/disko.nix
{ config, lib, pkgs, ... }:

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
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
            # LVM partition that will take the rest of the space
            lvm = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "vg0"; # Volume group name
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      vg0 = { # This must match the vg name above
        type = "lvm_vg";
        lvs = {
          # Root logical volume
          root = {
            size = "100G"; # Adjust size as needed
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
          # Persistent storage logical volume for impermanence
          persist = {
            size = "100%FREE"; # Use all remaining space
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
}
