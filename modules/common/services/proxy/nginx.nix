# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  config,
  lib,
  ...
}:
let
  cfg = config.maximizzar.modules.services.proxy;
  sslCertificate = "/var/lib/acme/maximizzar.org/fullchain.pem";
  sslCertificateKey = "/var/lib/acme/maximizzar.org/key.pem";
  sslTrustedCertificate = "/var/lib/acme/maximizzar.org/chain.pem";
in
{
  config = lib.mkIf cfg.enable {

    services.nginx = {
      enable = true;
      statusPage = true;
      enableReload = false;

      sslProtocols = "TLSv1.3";
    };

    services.nginx.upstreams = {

      "authelia-backend".servers = {
        "auth.dmz.genesis.prod.maximizzar.org:9091" = { };
      };

      "forgejo-backend".servers = {
        "forgejo.srv.genesis.prod.maximizzar.org:443" = { };
      };

      "prometheus-backend".servers = {
        "prometheus.srv.genesis.prod.maximizzar.org:443" = { };
      };

    };

    services.nginx.virtualHosts = {
      "authelia-vhost" = lib.mkIf cfg.authelia.enable {
        serverName = "auth.maximizzar.org";

        forceSSL = true;
        useACMEHost = "maximizzar.org";

        sslCertificate = sslCertificate;
        sslCertificateKey = sslCertificateKey;
        sslTrustedCertificate = sslTrustedCertificate;

        kTLS = true;
        quic = true;
        http3_hq = true;

        locations."/" = {
          proxyPass = "https://authelia-backend";
        };
      };

      "forgejo-vhost" = lib.mkIf cfg.forgejo.enable {
        serverName = "forgejo.maximizzar.org";

        forceSSL = true;
        useACMEHost = "maximizzar.org";

        sslCertificate = sslCertificate;
        sslCertificateKey = sslCertificateKey;
        sslTrustedCertificate = sslTrustedCertificate;

        kTLS = true;
        quic = true;
        http3_hq = true;

        locations."/" = {
          proxyPass = "https://forgejo-backend";
        };
      };

      "prometheus-vhost" = lib.mkIf cfg.prometheus.enable {
        serverName = "prometheus.maximizzar.org";

        addSSL = true;
        useACMEHost = "maximizzar.org";

        locations."/" = {
          proxyPass = "https://prometheus-backend";
        };
      };

    };
  };
}
