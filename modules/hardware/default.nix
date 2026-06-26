# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ inputs, ... }: {
  imports = [
    ./boot-systemd.nix
    ./boot-grub.nix

    inputs.nixos-facter-modules.nixosModules.facter
    ./hardware-configuration-kvm.nix

    ./root-disk.nix
  ];
}
