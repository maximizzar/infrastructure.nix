# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ inventory, pkgs, ... }: let
  sites = inventory.sites;
  nbg = inventory.sites.nbg.router.interfaces.lan;
  genesis = inventory.sites.genesis.router.interfaces.lan;
in {
  services.bind.zones."maximizzar.org" = {
    master = true;
    file = pkgs.writeText "zone-maximizzar.org" ''
      $ORIGIN maximizzar.org.
      $TTL 300

      @ IN SOA ns1.maximizzar.org. hostmaster.maximizzar.org. ( 1 3h 1h 1w 1h )
      @ IN NS ns1

      ns1 IN AAAA fd80:3aa8:691a:100::1

      root.ca IN AAAA fd19:38bc:a21d:1abf:be24:11ff:fe6c:5622

      ; transit network
      nbg.transit IN AAAA ${sites.nbg.router.interfaces.transit.address}
      genesis.transit IN AAAA ${sites.genesis.router.interfaces.transit.address}

      ; nbg vps hosts
      ${nbg.hosts.gw.name} IN AAAA ${nbg.hosts.gw.ip}
      ${nbg.hosts.proxy.name} IN AAAA ${nbg.hosts.proxy.ip}

      ${nbg.hosts.static.name} IN AAAA ${nbg.hosts.static.ip}

      ; genesis hosts
      ${genesis.hosts.gw.name} IN AAAA ${genesis.hosts.gw.ip}
      ${genesis.hosts.proxy.name} IN AAAA ${genesis.hosts.proxy.ip}

      ${genesis.hosts.navidrome.name} IN AAAA ${genesis.hosts.navidrome.ip}
      ${genesis.hosts.jellyfin.name} IN AAAA ${genesis.hosts.jellyfin.ip}
      ${genesis.hosts.static.name} IN AAAA ${genesis.hosts.static.ip}

    '';
  };

  services.bind.zones."e.a.c.5.f.8.4.9.5.9.d.f.ip6.arpa." = {
    master = true;
    file = pkgs.writeText "zone-e.a.c.5.f.8.4.9.5.9.d.f.ip6.arpa" ''
      $ORIGIN e.a.c.5.f.8.4.9.5.9.d.f.ip6.arpa.
      $TTL 300

      @ IN SOA ns1.maximizzar.org. hostmaster.maximizzar.org. ( 1 3h 1h 1w 1h )
        IN NS ns1.maximizzar.org.

      ; transit network
      1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0 IN PTR nbg.transit.maximizzar.org.
      2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0 IN PTR genesis.transit.maximizzar.org.

    '';
  };

  services.bind.zones."a.1.9.6.8.a.a.3.0.8.d.f.ip6.arpa." = {
    master = true;
    file = pkgs.writeText "zone-a.1.9.6.8.a.a.3.0.8.d.f.ip6.arpa" ''
      $ORIGIN a.1.9.6.8.a.a.3.0.8.d.f.ip6.arpa.
      $TTL 300

      @ IN SOA ns1.maximizzar.org. hostmaster.maximizzar.org. ( 1 3h 1h 1w 1h )
        IN NS ns1.maximizzar.org.

      ; nbg vps hosts
      ${nbg.hosts.gw.ip6-arpa} IN PTR ${nbg.hosts.gw.fqdn}.
      ${nbg.hosts.proxy.ip6-arpa} IN PTR ${nbg.hosts.proxy.fqdn}.

      ${nbg.hosts.static.ip6-arpa} IN PTR ${nbg.hosts.static.fqdn}.

      ; genesis hosts
      ${genesis.hosts.gw.ip6-arpa} IN PTR ${genesis.hosts.gw.fqdn}.
      ${genesis.hosts.proxy.ip6-arpa} IN PTR ${genesis.hosts.proxy.fqdn}.

      ${genesis.hosts.navidrome.ip6-arpa} IN PTR ${genesis.hosts.navidrome.fqdn}.
      ${genesis.hosts.jellyfin.ip6-arpa} IN PTR ${genesis.hosts.jellyfin.fqdn}.
      ${genesis.hosts.static.ip6-arpa} IN PTR ${genesis.hosts.static.fqdn}.

    '';
  };
}