# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/hardware/default.nix
{ ... }: {
    imports = [
        ./qemuDisk10gb.nix
        ./qemu.nix
    ];
}
