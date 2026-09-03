# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.maximizzar.modules.services.nameserver;
in
{
  config = lib.mkIf cfg.primary {
    services.bind.zones."maximizzar.org" = {
      master = true;
      file = pkgs.writeText "zone-maximizzar.org" ''
        $ORIGIN maximizzar.org.
        $TTL 300

        @ IN SOA ns.maximizzar.org. hostmaster.maximizzar.org. ( ${cfg.serialNumber} 3h 1h 1w 1h )
        @ IN NS ns.maximizzar.org.

        ns                            IN AAAA fd80:3aa8:691a:ff53:52e5:75ff:fe61:13c7
        root.ca                       IN CNAME ca.dmz.genesis.prod

        @                             IN AAAA fd80:3aa8:691a:ff00:4e:9fff:fe83:50a9
        *                             IN CNAME @

        ;; nbg
        endpoint.nbg.prod             IN AAAA 2a01:4f8:c2c:bd86:a2:57ff:fea0:dd70
        gw.nbg.prod                   IN AAAA fd80:3aa8:691a:fe00:a2:57ff:fea0:dd70

        ;; genesis
        resolver.genesis.prod         IN AAAA fd80:3aa8:691a:ff53:4b:64ff:fe2d:8169

        ;; genesis dmz (20)
        gw.dmz.genesis.prod           IN AAAA fd80:3aa8:691a:ff01:be24:11ff:feee:cfc8
        ca.dmz.genesis.prod           IN AAAA fd80:3aa8:691a:ff01:2558:9eb0:8a8f:ddb7
        auth.dmz.genesis.prod         IN AAAA fd80:3aa8:691a:ff01:be24:11ff:feb7:63dd

        ;; genesis srv (21)
        gw.srv.genesis.prod           IN AAAA fd80:3aa8:691a:ff02:be24:11ff:febe:1cf
        prometheus.srv.genesis.prod   IN AAAA fd80:3aa8:691a:ff02:be24:11ff:febb:2839
        forgejo.srv.genesis.prod      IN AAAA fd80:3aa8:691a:ff02:be24:11ff:fe1c:d263
        forgejo                       IN CNAME @
        ssh.forgejo                   IN CNAME forgejo.srv.genesis.prod

      '';
    };
  };
}
