# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/services/attic/default.nix
{ inputs, lib, pkgs, ... }: let
    attic = inputs.attic;

    fqdn = "attic.core.prod.maximizzar.org";

    storagePath = "/var/lib/atticd/storage";
    virtioTag = "nix-store";

in {
    # Attic Daemon Service
    services.atticd = {
        enable = true;
        package = attic.packages.${pkgs.system}.attic-server;
        environmentFile = "/etc/atticd.env";

        settings = {
            listen = "[::1]:8080";
            database.url = "postgresql:///atticd?host=/run/postgresql";

            storage = {
                type = "local";
                path = "${storagePath}";
            };

            jwt.algorithm = "RS256";

            chunking = {
                nar-size-threshold = 64 * 1024; # 64 KiB
                min-size = 16 * 1024; # 16 KiB
                avg-size = 64 * 1024; # 64 KiB
                max-size = 256 * 1024; # 256 KiB
            };
        };
    };

    # Atticd Database
    services.postgresql = {
        enable = true;
        package = pkgs.postgresql_15;
        ensureDatabases = [ "atticd" ];
        ensureUsers = [{
            name = "atticd";
            ensureDBOwnership = true;
        }];
    };

    # NGINX Service configuration
    services.nginx = {
        enable = true;
        validateConfigFile = true;

        # Global Config
        clientMaxBodySize = "0";

        # Attic VHost
        virtualHosts."${fqdn}" = {
            serverName = fqdn;
            enableACME = true;
            quic = true;
            kTLS = true;
            http3 = true;
            http2 = true;
            forceSSL = true;

            # Locations
            locations."/" = {
                proxyPass = "http://[::1]:8080";
                proxyWebsockets = true;
                extraConfig = ''
                    proxy_read_timeout 300s;
                    proxy_connect_timeout 75s;
                '';
            };
        };
    };

    # TLS-cert for https
    security.acme.certs."${fqdn}" = {
        domain = "${fqdn}";
        group = "nginx";
        webroot = "/var/lib/acme/acme-challenge";
    };

    # Firewall
    networking.firewall = {
        allowedTCPPorts = [ 80 443 ];
        allowedUDPPorts = [ 80 443 ];
    };

    # VirtioFS for nix-store files
    fileSystems."${storagePath}" = {
        device = virtioTag;
        fsType = "virtiofs";
        options = [ "defaults" "nofail" ];
    };

    systemd.services.atticd.serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "atticd";
        Group = "atticd";

        ReadWritePaths = [ storagePath ];
    };

    users.users.atticd = {
        isSystemUser = true;
        group = "atticd";
    };
    users.groups.atticd = {};
}
