# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/common/networkd.nix
{ config, pkgs, lib, ... }: {
    networking.useNetworkd = true;
    networking.useDHCP = false;

    systemd.network.networks."40-ens18" = {
            matchConfig.Name = "ens18";

            networkConfig.DHCP = "ipv4";
            networkConfig.IPv6AcceptRA = true;

            linkConfig.RequiredForOnline = "routable";
    };
}
