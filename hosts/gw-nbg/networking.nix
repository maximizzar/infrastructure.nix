# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# gw-nbg/networking
{ inventory, ... }:
let
  wan = "eth0";

  site = inventory.sites.nbg;
  hosts-nbg-lan = inventory.sites.nbg.router.interfaces.lan.hosts;
in
{
  networking = {
    firewall.enable = false;
    useNetworkd = true;
    useDHCP = false;

    hostName = "gw-nbg";
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

    address = [
      "2a01:4f8:c2c:bd86::1/64"
      "fd80:3aa8:691a:100::1/64"
    ];

    routes = [
      {
        Gateway = "fe80::1";
        GatewayOnLink = true;
      }
    ];

    dhcpV4Config.UseDNS = false;
    ipv6AcceptRAConfig.UseDNS = false;
  };

  # Bridge for Containers
  systemd.network.netdevs."20-br-lan" = {
    netdevConfig = {
      Name = "br-lan";
      Kind = "bridge";
    };
  };

  # assign IP to bridge (router role)
  systemd.network.networks."30-br-lan" = {
    matchConfig.Name = "br-lan";

    networkConfig = {
      IPv6AcceptRA = false;
      IPv6SendRA = true;
      IPv6Forwarding = true;
    };

    address = [ site.router.interfaces.lan.address ];
  };
}