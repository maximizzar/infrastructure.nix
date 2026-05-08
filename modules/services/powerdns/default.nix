# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/powerdns/default.nix
{ inputs, pkgs, ... }: let
    fqdn = "ns.core.prod.maximizzar.org";
    caStore = "/etc/ssl/certs/ca-certificates.crt";

    minTLS  = "tls1.2";
    tlsCert = "/var/lib/acme/${fqdn}/cert.pem";
    tlsKey = "/var/lib/acme/${fqdn}/key.pem";
    dnsdistConfig = pkgs.replaceVars ./dnsdist.lua {
        inherit caStore minTLS tlsCert tlsKey;
    };

    hagezi-rpz = pkgs.fetchFromGitHub {
        owner = "hagezi";
        repo = "dns-blocklists";
        rev = "main";
        sha256 = "sha256-eEt4jxQ+6PdkvS0owylLh754BiHMPyjnScQXbbxkLy0=";
    };

in {
    # TLS-cert for DoT and DoH
    security.acme.certs."${fqdn}" = {
        domain = "${fqdn}";
        webroot = "/var/lib/acme/acme-challenge";
        group = "dnsdist";
        postRun = "systemctl reload dnsdist.service";
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
        extraConfig = builtins.readFile dnsdistConfig;
    };

    # DNS Recursor
    services.pdns-recursor = {
        enable = true;
        dns = {
            address = [ "127.0.0.1" ];
            allowFrom = [ "127.0.0.0/8" ];
            port = 5300;
        };

        dnssecValidation = "log-fail";
        exportHosts = false;
        forwardZonesRecurse = {
            "." = "127.0.0.1:5353";
        };

        serveRFC1918 = true;
        luaConfig = builtins.readFile ./rpz.lua;
    };

    # 4. Allow dnsdist to see the cert directory through the systemd sandbox
    systemd.services.dnsdist.serviceConfig.ReadOnlyPaths = [ "/var/lib/acme/${fqdn}" ];

    networking.firewall = {
        allowedTCPPorts = [ 53 443 853 ];
        allowedUDPPorts = [ 53 443 ];
  };
}
