# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  imports = [
    ./boot-systemd.nix
    ./boot.grub.nix

    ./hardware-configuration-kvm.nix

    ./root-disk.nix
  ];
}
