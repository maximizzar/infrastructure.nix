# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ inventory, ... }:
let
  sites = inventory.sites;
  peers = sites.transit.peers;
in
{
  networking = {
    firewall.allowedUDPPorts = [ 51820 ];
    wireguard.enable = true;
  };

  networking.wireguard.interfaces.wg0 = {
    allowedIPsAsRoutes = true;

    # The IP addresses of the interface
    ips = [ "${peers.genesis.address}" ];

    # WireGuard Port
    listenPort = 51820;

    # Path to the private key file.
    privateKeyFile = "/etc/wireguard/wg0.key";

    peers = [
      {
        name = "Site: nbg";
        publicKey = peers.nbg.publicKey;
        allowedIPs = [
          sites.transit.Prefix
          sites.overlay.Prefix
        ];

        persistentKeepalive = 25;
        endpoint = "[2a01:4f8:c2c:bd86:a2:57ff:fea0:dd70]:51820";
      }

    ];
  };

}
