# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.hardware.rootDisk;
in
{
  options.maximizzar.modules.hardware.rootDisk = lib.mkEnableOption "root-disk";
  config = lib.mkIf cfg.enable {
    disko.devices.disk.main.imageSize = "8G";
    disko.imageBuilder.imageFormat = "qcow2";

    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/vda";

      content = {
        type = "gpt";

        partitions = {
          esp = {
            priority = 1;
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
            name = "root";
            size = "100%";

            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "noatime" ];
            };
          };
        };
      };
    };
  };
}
