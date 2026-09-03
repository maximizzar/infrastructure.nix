# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ inventory, ... }:
let
  sites = inventory.sites;
  peers = sites.transit.peers;
in
{
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard.interfaces.wg0 = {
    ips = [ "${peers.nbg.address}" ];

    # WireGuard Port
    listenPort = 51820;

    # Path to the private key file.
    privateKeyFile = "/etc/wireguard/wg0.key";

    peers = [
      {
        name = "Site: genesis";
        publicKey = peers.genesis.publicKey;
        allowedIPs = [
          peers.genesis.address
          sites.genesis.Prefix
        ];
      }

      {
        name = "Site: ext1";
        publicKey = peers.ext1.publicKey;
        allowedIPs = [
          peers.ext1.address
          sites.ext1.Prefix
        ];
      }

    ];
  };

}
