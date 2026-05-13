# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/common/resolved.nix
{ config, pkgs, lib, ... }: {
    services.resolved = {
        dnssec = "allow-downgrade";
    };
}
