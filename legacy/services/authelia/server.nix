# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.services.authelia;
  fqdn = "auth.srv.genesis.prod.maximizzar.org";
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 9091 ];
    security.acme.certs."${fqdn}" = {
      domain = fqdn;
      webroot = "/var/lib/acme/acme-challenge";
      group = "authelia-maximizzar.org";
      postRun = "systemctl reload authelia-maximizzar.org";
    };

    services.authelia.instances."maximizzar.org" = {
      settings.server = {
        address = "tcp://[::]:9091";
        tls = {
          certificate = "/var/lib/acme/${fqdn}/fullchain.pem";
          key = "/var/lib/acme/${fqdn}/key.pem";
        };
      };
    };

  };
}
