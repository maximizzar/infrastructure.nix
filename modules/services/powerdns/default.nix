# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/powerdns/default.nix
{ config, pkgs, lib, ... }:
let
    fqdn = "ns.core.prod.maximizzar.org";
    caStore = "/etc/ssl/certs/ca-certificates.crt";

    minTLS  = "tls1.2";
    tlsCert = "/var/lib/acme/${fqdn}/cert.pem";
    tlsKey = "/var/lib/acme/${fqdn}/key.pem";
    dnsdistConfig = pkgs.substituteAll {
        src = ./dnsdist.lua;
        minTLS = minTLS;
        tlsCert = tlsCert;
        tlsKey = tlsKey;
    };
in {
    # TLS-cert for DoT and DoH
    security.acme.certs."${fqdn}" = {
        domain = "${fqdn}";
        webroot = "/var/lib/acme/acme-challenge";
        group =  "";
        postRun = "systemctl reload .service";
    };

    # NGINX vHost for ACME
    services.nginx.virtualHosts."${fqdn}" = {
        locations."/.well-known/acme-challenge" = {
            root = "/var/lib/acme/acme-challenge";
        };
    };

    # DNS Forwarder
    services.dnsdist = {
        enable = true;
        extraConfig = builtins.readFile ./dnsdist.lua;
    };
    networking.firewall = {
        allowedTCPPorts = [ 53 443 853 ];
        allowedUDPPorts = [ 53 443 ];
  };
}
