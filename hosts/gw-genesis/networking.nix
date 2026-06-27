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

    address = [
      "fd80:3aa8:691a:200::1/64"
    ];

    dhcpV4Config.UseDNS = false;
    ipv6AcceptRAConfig.UseDNS = false;
  };

  # Bridge for Containers
  systemd.network.netdevs."20-br1" = {
    netdevConfig = {
      Name = "br1";
      Kind = "bridge";
    };
  };

  # assign IP to bridge (router role)
  systemd.network.networks."30-br1" = {
    matchConfig.Name = "br1";

    networkConfig = {
      IPv6AcceptRA = false;
      IPv6SendRA = true;
      IPv6Forwarding = true;
    };

    address = [ site.router.interfaces.lan.address ];
  };

  # lan Network
  systemd.network.networks."30-${lan}" = {
    Description = "DMZ for VMs";
    DHCP = "no";
    IPv6LinkLocalAddressGenerationMode = "eui64";

    IPv6PrivacyExtensions = false;
    IPv6AcceptRA = true;

    IPv6SendRA = true;
    IPv6Forwarding = true;

    address = [
      "fd80:3aa8:691a:201::1/64"
    ];

  };
}
