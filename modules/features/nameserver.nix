# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ inputs, ... }: {
  flake.nixosModules.nameserver =
    {
      inventory,
      lib,
      pkgs,
      ...
    }:

    let
      dns = inputs.dns;
      domain = "maximizzar.org";

      hosts = inventory.overlay.sites.genesis.hosts;

      zone = with dns.lib.combinators; {
        SOA = {
          nameServer = "ns.${domain}.";
          adminEmail = "hostmaster.${domain}";
          serial = 2026102801;
        };

        useOrigin = true;
        NS = [ "ns.${domain}." ];

        AAAA = [
          { address = "fe80::1"; }
        ];

        subdomains = {
          ns.AAAA = [ "fd80:3aa8:691a:ff02::53" ];
        }
        // lib.mapAttrs' (
          name: host:
          lib.nameValuePair name {
            AAAA = [ host.Ipv6Address ];
          }
        ) (lib.filterAttrs (_: host: host.network == "srv") hosts);
      };

      zoneFile = dns.lib.toString domain zone;

    in
    {
      services.bind = {
        enable = true;
        zones.${domain} = {
          master = true;
          file = pkgs.writeText "${domain}.zone" zoneFile;
        };
      };
    };
}
