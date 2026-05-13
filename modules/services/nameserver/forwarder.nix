# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/core/nameserver/forwarder.nix
{ inputs, pkgs, hostname, ns-primary, ... }: let
    domain = "core.prod.maximizzar.org";
    fqdn = hostname + "." + domain;

    caStore = "/etc/ssl/certs/ca-certificates.crt";
    minTLS  = "tls1.2";
    tlsCert = "/var/lib/acme/${fqdn}/cert.pem";
    tlsKey = "/var/lib/acme/${fqdn}/key.pem";

    # DNS Recursor
    recursorLoopback = 5353;

    # DNS Forwarder
    dnsdistConfig = pkgs.replaceVars ./config/dnsdist.lua {
        inherit caStore minTLS tlsCert tlsKey;
    };

    hagezi-rpz = pkgs.fetchFromGitHub {
        owner = "hagezi";
        repo = "dns-blocklists";
        rev = "main";
        sha256 = "sha256-eEt4jxQ+6PdkvS0owylLh754BiHMPyjnScQXbbxkLy0=";
    };
in {
    networking.hostName = hostname;
    networking.domain = domain;
    services.resolved.enable = false;
    networking.firewall.enable = true;

    environment.systemPackages = with pkgs; [
        dnsutils
    ];

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
        serveRFC1918 = true;
        luaConfig = builtins.readFile ./config/rpz.lua;

        forwardZonesRecurse = {
            "." = "127.0.0.1:5353";
        };

        forwardZones = {
            "maximizzar.org" = "${ns-primary}";
            "a.1.9.6.8.a.a.3.0.8.d.f.ip6.arpa" = "${ns-primary}";
        };
    };

    # 4. Allow dnsdist to see the cert directory through the systemd sandbox
    systemd.services.dnsdist.serviceConfig.ReadOnlyPaths = [ "/var/lib/acme/${fqdn}" ];

    networking.firewall = {
        allowedTCPPorts = [ 53 443 853 ];
        allowedUDPPorts = [ 53 443 ];
    };
}
