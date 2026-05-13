# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/core/prometheus.nix
{ hostname, domain, ... }: let
        fqdn = "${hostname}.${domain}";

in {
    networking.hostName = hostname;
    networking.firewall.allowedTCPPorts = [ 9090 ];

    # TLS-cert for https and mTLS
    security.acme.certs."${fqdn}" = {
        domain = "${fqdn}";
        webroot = "/var/lib/acme/acme-challenge";
        postRun = "systemctl reload prometheus && systemctl reload nginx";
    };

    # NGINX vHost for ACME
    services.nginx.virtualHosts."${fqdn}" = {
        locations."/.well-known/acme-challenge" = {
            root = "/var/lib/acme/acme-challenge";
        };
    };

    # Prometheus Service
    services.prometheus = {
        enable = true;
        port = 9090;
    };
}
