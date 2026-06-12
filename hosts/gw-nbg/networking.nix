# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# gw-nbg/networking
{ inventory, ... }:
let
  wan = "eth0";
  site = inventory.sites.nbg;
in
{
  networking = {
    firewall.enable = false;
    useNetworkd = true;
    useDHCP = false;

    hostName = "gw-nbg";
    nameservers = [
      "2a01:4ff:ff00::add:2"
      "2a01:4ff:ff00::add:1"
      "185.12.64.2"
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

    address = [
      "2a01:4f8:c2c:bd86::1/64"
    ];

    vlan = [ "vlan10" ];

    routes = [
      {
        Gateway = "fe80::1";
        GatewayOnLink = true;
      }
    ];

    dhcpV4Config.UseDNS = false;
    ipv6AcceptRAConfig.UseDNS = false;
  };
  # Subnet configuration
  systemd.network = {
    netdevs."vlan10" = {
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan10";
      };
      vlanConfig.Id = 10;
    };
      networks."20-lan" = {
        matchConfig.Name = "vlan10";

        address = [
          site.router.interfaces.lan.address
        ];
      };
  };
}
