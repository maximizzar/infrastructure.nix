# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  inventory,
  lib,
  ...
}:
let
  sites = inventory.sites;
  selfSite = inventory.sites.nbg;
in
{
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard.interfaces.wg0 = {
    # the IP address and subnet of this peer
    ips = [ "${selfSite.router.interfaces.transit.address}/128" ];

    # WireGuard Port
    listenPort = 51820;

    # Path to the private key file.
    privateKeyFile = "/etc/wireguard/wg0.key";

    peers = lib.mapAttrsToList (_name: site: {
      publicKey = site.router.wgPubkey;

      allowedIPs = [
        "${site.router.interfaces.transit.address}/128"
        site.prefix
      ];
    }) sites;
  };
}
