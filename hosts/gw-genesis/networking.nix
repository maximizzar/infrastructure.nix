# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# gw-genesis/networking
{ inventory, ... }:
let
  wan = "ens18";
  lan = "ens19";
  site = inventory.sites.genesis;
in
{
  networking = {
    useNetworkd = true;
    useDHCP = false;

    hostName = "gw-genesis";
  };
  systemd.network.networks."30-${wan}" = {
    matchConfig.Name = wan;
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

      # send ULA into lan
      IPv6SendRA = true;
      IPv6Forwarding = true;
    };

    dhcpV4Config.UseDNS = false;
    ipv6AcceptRAConfig.UseDNS = false;
  };
}
