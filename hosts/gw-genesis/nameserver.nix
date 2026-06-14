# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ pkgs, inventory, ... }:
let
  hosts = inventory.sites.nbg.router.interfaces.lan.hosts;
in
{
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.bind = {
    enable = true;

    zones."genesis.maximizzar.org" = {
      master = true;
      file = pkgs.writeText "zone-genesis.maximizzar.org" ''
        $ORIGIN genesis.maximizzar.org.
        $TTL 300

        @ IN SOA ${hosts.ns1.fqdn}. hostmaster.maximizzar.org. ( 1 3h 1h 1w 1h )
        @ IN NS ${hosts.ns1.name}
        @ IN AAAA ${hosts.gw.ip}

        ; hosts
        ${hosts.gw.name} IN AAAA ${hosts.gw.ip}
        ${hosts.ns1.name} IN AAAA ${hosts.ns1.ip}
      '';
    };
  };
}