# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/vs/forgejo.nix
{ pkgs, ... }: let

in {
    environment.systemPackages = with pkgs; [
        dnsutils
        openssl_4_0
        mtr
    ];

    networking.firewall.enable = false;
}
