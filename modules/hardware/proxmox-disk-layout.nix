# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/hardware/proxmox-disk-layout.nix
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda"; # Standard VirtIO drive path
        imageSize = "10G";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1; # Ensure ESP is first
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              priority = 2;
              name = "root"; # Matches partlabel disk-main-root
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  # User QCow2 for less storage use
  disko.imageBuilder.imageFormat = "qcow2";
}
