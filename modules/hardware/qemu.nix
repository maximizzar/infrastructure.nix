# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/hardware/qemu.nix
{ lib, ... }: {
    flake.nixosModules.hardware-qemu = {
        # Bootloader settings for systemd-boot
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Standard QEMU Kernel Modules
        boot.initrd.availableKernelModules = [
            "ahci"        # SATA support
            "virtio_pci"  # Required for VirtIO devices
            "virtio_scsi" # Standard Proxmox SCSI controller
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

        # QEMU Guest Agent (highly recommended)
        services.qemuGuest.enable = true;

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
