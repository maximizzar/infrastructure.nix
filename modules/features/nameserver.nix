# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ inputs, inventory, ... }: {
  flake.nixosModules.nameserver =
    {
      self,
      lib,
      pkgs,
      ...
    }:

    let
      dns = inputs.dns;
      domain = "maximizzar.org";

      hosts = inventory.overlay.sites.genesis.hosts;

      # Convert the inventory FQDN into a zone-relative record name
      recordName =
        host:
        let
          relativeDomain =
            if host.domain == domain then
              ""
            else if lib.hasSuffix ".${domain}" host.domain then
              lib.removeSuffix ".${domain}" host.domain
            else
              throw "Host ${host.hostName}: domain ${host.domain} is outside DNS zone ${domain}";
        in
        lib.concatStringsSep "." (
          lib.filter (part: part != "") [
            host.hostName
            relativeDomain
          ]
        );

      zone = with dns.lib.combinators; {
        SOA = {
          nameServer = "ns.${domain}.";
          adminEmail = "hostmaster.${domain}";
          serial = self.lastModified;
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
          lib.nameValuePair (recordName host) {
            AAAA = [ host.Ipv6Address ];
          }
        ) (lib.filterAttrs (_: host: host.network != "lan") hosts);
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

      networking.firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };
    };
}
