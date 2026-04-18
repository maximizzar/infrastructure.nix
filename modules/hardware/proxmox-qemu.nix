# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/hardware/proxmox-qemu.nix
{ config, lib, pkgs, modulesPath, ... }: {
    # Bootloader settings for systemd-boot
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Standard Proxmox / QEMU Kernel Modules
    boot.initrd.availableKernelModules = [
        "virtio_pci"  # Required for VirtIO devices
        "virtio_scsi" # Standard Proxmox SCSI controller
        "ahci"        # SATA support
        "usbhid"      # Keyboard/Mouse
        "sr_mod"      # CD-ROM support
    ];

    boot.initrd.kernelModules = [
        "virtio_pci"
        "virtio_blk"
        "virtio_scsi"
    ];

    boot.kernelModules = [ "kvm-intel" "kvm-amd" ];
    boot.extraModulePackages = [ ];

    # QEMU Guest Agent (highly recommended for Proxmox stats/shutdowns)
    services.qemuGuest.enable = true;

    # Performance and hardware tweaks
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
