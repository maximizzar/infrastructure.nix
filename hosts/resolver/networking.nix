# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ ... }:
let
  wan = "ens18";
in
{
  networking = {
    useNetworkd = true;
    useDHCP = false;

    hostName = "resolver";
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
    };

    dhcpV4Config.UseDNS = false;
    ipv6AcceptRAConfig.UseDNS = false;
  };
}
