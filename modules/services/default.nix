# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/default.nix
{ lib, ... }:
let

in {
    imports = [
        ./prometheus-client.nix
        ./prometheus-server.nix
        ./sshd.nix
        ./nameserver
    ];
}
