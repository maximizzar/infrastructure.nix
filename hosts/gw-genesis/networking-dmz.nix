# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ inventory, ... }:
let
  site = inventory.sites.genesis;
in
{
  # DMZ Networking
  systemd.network.networks."10-dmz" = {
    matchConfig.Name = "ens19";

    networkConfig = {
      # Address Generation
      IPv6AcceptRA = true;
      IPv6PrivacyExtensions = false;
      IPv6LinkLocalAddressGenerationMode = "eui64";

      IPv6SendRA = true;
      DHCP = "ipv6";
      DHCPPrefixDelegation = true;
    };

    dhcpPrefixDelegationConfig = {
      UplinkInterface = "ens18";
      SubnetId = "0";
      Announce = true;
    };

    ipv6SendRAConfig = {
      DNS = "fd80:3aa8:691a:ff02:be24:11ff:feb5:cc6d";
      EmitDNS = true;
      OtherInformation = true;
    };

    # Static ULA config
    ipv6Prefixes = [
      {
        Assign = true;
        Prefix = site.networks.dmz.Prefix;
      }
    ];

  };
}
