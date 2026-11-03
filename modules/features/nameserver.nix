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
        TTL = 300;
        NS = [ "ns.${domain}." ];

        A = [ { address = hosts.gw.Ipv4Address; } ];
        AAAA = [ { address = hosts.gw.Ipv6Address; } ];

        subdomains = {
          auth.AAAA = [ hosts.gw.Ipv6Address ];
          ca.subdomains = {
            root.AAAA = [ "fd80:3aa8:691a:ff01:be24:11ff:fe6c:5622" ];
          };
          forgejo = {
            AAAA = [ hosts.gw.Ipv6Address ];
            subdomains = {
              ssh.AAAA = [ hosts.forgejo.Ipv6Address ];
            };
          };

          ns.AAAA = [ hosts.resolver.containers.nameserver.Ipv6Address ];
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
      environment.systemPackages = with pkgs; [
        dnsutils
        dig
      ];

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
