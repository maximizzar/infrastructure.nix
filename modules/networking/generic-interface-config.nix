# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/networking/generic-interface-config.nix
{ config, pkgs, lib, ... }: {
    flake.nixosModules.networking-generic-interface-config = {
        networking.useNetworkd = true;
        networking.useDHCP = false;
        networking.nameservers = [
            "fd80:3aa8:691a:20:be24:11ff:fec9:4372#ns-primary.core.prod.maximizzar.org"
            "fd80:3aa8:691a:20:be24:11ff:fe3b:7814#ns-secondary.core.prod.maximizzar.org"
        ];

        systemd.network.networks."40-ens18" = {
            matchConfig = {
                Name = "ens18";
                Virtualization = "vm";
            };

            linkConfig = {
                RequiredForOnline = "routable";
                RequiredFamilyForOnline = "ipv6";
            };

            networkConfig = {
                Description = "Main Interface";
                DHCP = "no";
                IPv6LinkLocalAddressGenerationMode = "eui64";

                IPv6PrivacyExtensions = false;
                IPv6AcceptRA = true;
            };

            dhcpV4Config.UseDNS = false;
            ipv6AcceptRAConfig.UseDNS = false;
        };

        services.resolved = {
            dnsovertls = "opportunistic";
            dnssec = "allow-downgrade";
            fallbackDns = [];
            domains = [ "~." ];
        };
    };
}
