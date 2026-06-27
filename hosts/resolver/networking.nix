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

  # Bridge for Containers
  systemd.network.netdevs."20-br1" = {
    netdevConfig = {
      Name = "br1";
      Kind = "bridge";
    };
  };

  # Enslave the physical interface to the bridge
  systemd.network.networks."30-${wan}" = {
    matchConfig.Name = wan;
    networkConfig.Bridge = "br1";
    linkConfig.RequiredForOnline = "enslaved";
  };

  # Handle all layer-3 traffic on the bridge interface
  systemd.network.networks."40-br1" = {
    matchConfig.Name = "br1";

    networkConfig = {
      IPv6AcceptRA = true;
      IPv6PrivacyExtensions = false;
      IPv6LinkLocalAddressGenerationMode = "eui64";

      DHCP = "ipv4";
    };

    dhcpV4Config.ClientIdentifier = "mac";
    ipv6AcceptRAConfig = {
      UseAutonomousPrefix = true;
      UseDNS = false;
    };

    linkConfig.RequiredForOnline = "routable";
  };

  # Essential sysctl adjustments on the host
  boot.kernel.sysctl = {
    # Allow the host to forward packets to/from your container network namespace
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.default.forwarding" = 1;

    # Crucial: Ensure the host bridge interface doesn't ignore network RAs
    # once forwarding is globally activated.
    "net.ipv6.conf.br1.accept_ra" = 2;
  };
}
