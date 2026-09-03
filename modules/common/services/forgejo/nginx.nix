# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.services.forgejo;

  basedomain = "maximizzar.org";
  fqdn = "forgejo.srv.genesis.prod.${basedomain}";

in
{
  config = lib.mkIf cfg.enable {
    services.nginx.enable = true;
    services.nginx.virtualHosts."forgejo" = {
      serverName = fqdn;

      sslCertificate = "/var/lib/acme/${fqdn}/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/${fqdn}/key.pem";
      sslTrustedCertificate = "/var/lib/acme/${fqdn}/chain.pem";

      forceSSL = true;
      kTLS = true;
      enableACME = true;

      quic = true;
      extraConfig = ''
        add_header Alt-Svc 'h3=":443"; ma=86400' always;
      '';

      locations."= /".extraConfig = ''
        return 302 /explore/repos;
      '';

      locations."/".proxyPass = "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}:";
    };
  };
}
