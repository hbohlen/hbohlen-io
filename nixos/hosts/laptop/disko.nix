{ config, lib, pkgs, ... }:

{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda"; # Assuming a virtual disk for initial setup/testing
        # For a real laptop, this would be something like "/dev/nvme0n1" or "/dev/sda"
        # You would need to adjust this based on your actual hardware.
        # For initial VM testing, /dev/vda is common.

        # Optional: Enable encryption
        # encryption = {
        #   enable = true;
        #   # You can specify a password or use a keyfile
        #   # passwordFile = "/path/to/keyfile";
        # };

        # Optional: Enable LVM
        # lvm = {
        #   enable = true;
        #   # volumeGroups = {
        #   #   vgmain = {
        #   #     type = "volumeGroup";
        #   #     create = true;
        #   #     logicalVolumes = {
        #   #       root = {
        #   #         size = "100%";
        #   #         fs = {
        #   #           type = "ext4";
        #   #           mountpoint = "/";
        #   #         };
        #   #       };
        #   #     };
        #   #   };
        #   # };
        # };

        # Define partitions
        partitions = [
          {
            name = "boot";
            size = "512M";
            type = "partition";
            fs = {
              type = "fat32";
              mountpoint = "/boot";
            };
          }
          {
            name = "swap";
            size = "8G"; # Example swap size
            type = "partition";
            fs = {
              type = "swap";
            };
          }
          {
            name = "root";
            size = "100%"; # Use remaining space
            type = "partition";
            fs = {
              type = "ext4";
              mountpoint = "/";
            };
          }
        ];
      };
    };
  };
}