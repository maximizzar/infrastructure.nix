# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  wan = "eth0";
in
{
  networking = {
    firewall.enable = false;
    useNetworkd = true;
    useDHCP = false;

    hostName = "gw-nbg";
    nameservers = [
      "fd80:3aa8:691a:fe00:bf:daff:feb2:a553"
    ];
  };

  systemd.network.links."10-${wan}" = {
    matchConfig.MACAddress = "92:00:08:2a:50:ae";

    linkConfig = {
      Name = wan;
      AlternativeName = "enx9200082a50ae";
    };
  };

  systemd.network.networks."30-${wan}" = {
    matchConfig.Name = wan;

    linkConfig = {
      RequiredForOnline = "routable";
      RequiredFamilyForOnline = "ipv6";
    };

    networkConfig = {
      Description = "Hetzner Uplink";

      DHCP = "ipv4";

      IPv6PrivacyExtensions = false;
      IPv6AcceptRA = false;
    };

    routes = [
      {
        Gateway = "fe80::1";
        GatewayOnLink = true;
      }
    ];

    dhcpV4Config.UseDNS = false;
    ipv6AcceptRAConfig.UseDNS = false;
  };

  # L2 Bridge for containers
  systemd.network.netdevs."20-br0" = {
    netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
  };

  # L3 Bridge for containers
  systemd.network.networks."20-br0" = {
    matchConfig.Name = "br0";

    linkConfig.MACAddress = "02:a2:57:a0:dd:70";
    networkConfig = {
      # Address Generation
      IPv6AcceptRA = "yes";
      IPv6PrivacyExtensions = false;
      IPv6LinkLocalAddressGenerationMode = "eui64";

      ConfigureWithoutCarrier = true;
      IPv6SendRA = true;
    };

    ipv6SendRAConfig = {
    };

    ipv6Prefixes = [
      {
        Assign = true;
        Prefix = "2a01:4f8:c2c:bd86::/64";
      }

      {
        Assign = true;
        Prefix = "fd80:3aa8:691a:fe00::/64";
      }
    ];
  };
}
