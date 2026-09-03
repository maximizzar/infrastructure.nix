# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  lib,
  inventory,
  ...
}:
let
  site = inventory.sites.genesis;
  wan_interface = "ens18";
in
{
  networking = {
    hostName = "resolver";
  };

  maximizzar.networking.vmNetworking.enable = true;

  # Force DHCP for v4 and v6
  systemd.network.networks."10-${wan_interface}" = {
    matchConfig.Name = wan_interface;
    networkConfig.DHCP = lib.mkForce true;
  };

  systemd.network.networks."10.ens19" = {
    matchConfig.Name = "ens19";

    networkConfig = {
      IPv6AcceptRA = true;
      IPv6PrivacyExtensions = false;
      IPv6LinkLocalAddressGenerationMode = "eui64";
    };
  };

  maximizzar.networking.ipForwarding.enable = true;
  maximizzar.networking.containerNetworking = {
    enable = true;
    mac = site.hosts.resolver.interfaces.br-container.mac;
    subnetId = "0";
    ulaPrefix = site.networks.ns.Prefix;
  };

}
