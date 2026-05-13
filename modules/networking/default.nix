# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/networking/default.nix
{ ... }: let

in {
    flake.nixosModules = {
        networking-ip-forwarding = ./ip-forwarding.nix;

    };

    imports = [
        ./generic-interface-config.nix
    ];
}
