# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/common/avahi.nix
{ config, pkgs, lib, ... }: {
    services.avahi = {
        enable = true;

        ipv4 = false;
        ipv6 = true;

        nssmdns4 = false;
        nssmdns6 = true;

        openFirewall = true;

        publish = {
            enable = true;
            userServices = true;
        };
    };
}
