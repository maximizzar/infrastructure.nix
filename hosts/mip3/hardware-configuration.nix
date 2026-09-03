# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/luks-47298d79-cb92-4fb7-840e-0730c2ba7df0";
    fsType = "btrfs";
  };

  boot.initrd.luks.devices."luks-47298d79-cb92-4fb7-840e-0730c2ba7df0".device =
    "/dev/disk/by-uuid/47298d79-cb92-4fb7-840e-0730c2ba7df0";

  fileSystems."/home" = {
    device = "/dev/mapper/luks-47298d79-cb92-4fb7-840e-0730c2ba7df0";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/luks-47298d79-cb92-4fb7-840e-0730c2ba7df0";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/EC69-B90D";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/mapper/luks-35770c58-e4d0-40c2-ac88-8586d43fb541"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
