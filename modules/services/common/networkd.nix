# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/common/networkd.nix
{ config, pkgs, lib, ... }: {
    networking.useNetworkd = true;
    networking.useDHCP = false;

    systemd.network.networks."40-ens18" = {
        matchConfig = {
            Name = "ens18";
            Virtualization = "vm";
        };

        linkConfig = {
            RequiredForOnline = "routable";
            #RequiredFamilyForOnline = "ipv6";
        };

        networkConfig = {
            Description = "Main Interface";
            DHCP = "ipv4";
            LinkLocalAddressing = "yes";
            IPv6LinkLocalAddressGenerationMode = "eui64";

            IPv6PrivacyExtensions = false;
            IPv6AcceptRA = true;
        };
    };
}
