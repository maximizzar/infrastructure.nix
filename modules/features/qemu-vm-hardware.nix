# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inputs, ... }: {
  flake.nixosModules.qemuVmHardware = { lib, ... }: {
    imports = [
      self.nixosModules.systemdBoot

      inputs.disko.nixosModules.disko
      inputs.nixos-facter-modules.nixosModules.facter
    ];

    hardware.facter.reportPath = ./qemu-vm-facter.json;
    boot.growPartition = true;
    fileSystems."/boot".device = lib.mkForce "/dev/disk/by-label/ESP";
    fileSystems."/" = {
      autoResize = true;
      device = lib.mkForce "/dev/disk/by-label/nixos-root";
    };

    disko = {
      devices.disk.main.imageSize = lib.mkDefault "8G";
      imageBuilder.imageFormat = "qcow2";
    };

    disko.devices.disk.main = {
      type = "disk";

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
              extraArgs = [
                "-n"
                "ESP"
              ];
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          root = {
            priority = lib.mkDefault 2;
            name = "root";
            size = "100%";

            content = {
              type = "filesystem";
              format = "ext4";
              extraArgs = [
                "-L"
                "nixos-root"
              ];
              mountpoint = "/";
              mountOptions = [ "noatime" ];
            };
          };
        };
      };
    };

  };
}
