# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/ns/default.nix
{ inputs, pkgs, ... }: let
    fqdn = "forgejo.git.prod.maximizzar.org";

in {
    services.forgejo = {
        enable = true;

        database.type = "postgres";
        database.createDatabase = true;

        settings = {
            server = {
                DOMAIN = fqdn;
                ROOT_URL = "https://${fqdn}/";
                HTTP_ADDR = "127.0.0.1";
                HTTP_PORT = 3000;
            };

            actions.ENABLED = false;
            packages.ENABLED = false;
            federation.ENABLED = false;

            service = {
                DISABLE_REGISTRATION = true;
                REQUIRE_SIGNIN_VIEW = true;
            };

            openid = {
                ENABLE_OPENID_SIGNIN = false;
                ENABLE_OPENID_SIGNUP = false;
            };

            metrics.ENABLED = false;

            oauth2.ENABLE = true;
        };
    };

    # Harden forgejo systemd service
    systemd.services.forgejo = {
      serviceConfig = {
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateTmp = true;
        RestrictRealtime = true;
        NoNewPrivileges = true;
      };
    };

    # Create SQL dump for backup
    #services.postgresql.backup.enable = true;
    #services.postgresql.backup.location = "/var/lib/postgresql/backups";

    # NGINX Service configuration
    services.nginx = {
        enable = true;
        validateConfigFile = true;

        # Global Config

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
                proxyPass = "http://127.0.0.1:3000";
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
        allowedTCPPorts = [ 22 80 443 ];
        allowedUDPPorts = [ 80 443 ];
    };
}
