# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.monitoringConfiguration =
    {
      config,
      inventory,
      myLib,
      ...
    }:
    let
      host = inventory.overlay.sites.genesis.hosts.monitoring;
      modules = with self.nixosModules; [
        qemuVm
        monitoringSecrets

        webServer
      ];

      grafana_domain = "grafana." + host.hostName + "." + host.domain;
      prometheus_domain = "prometheus." + host.hostName + "." + host.domain;

      exporters = config.services.prometheus.exporters;
    in
    {
      imports = modules;

      networking = {
        inherit (host) hostName domain;
        nftables.enable = true;
        firewall = {
          enable = true;

        };
      };

      security.acme.certs = {
        "${grafana_domain}" = {
          domain = grafana_domain;
          webroot = "/var/lib/acme/acme-challenge";
          postRun = "systemctl reload nginx";
        };
        "${prometheus_domain}" = {
          domain = prometheus_domain;
          webroot = "/var/lib/acme/acme-challenge";
          postRun = "systemctl reload nginx";
        };
      };

      users.users."${config.services.nginx.user}".extraGroups = [ "grafana" ];

      services = {
        postgresql = {
          enable = true;
          ensureDatabases = [ config.services.grafana.settings.database.name ];
          ensureUsers = [
            {
              name = config.services.grafana.settings.database.user;
              ensureDBOwnership = true;
            }
          ];
        };

        nginx.virtualHosts."${grafana_domain}" = {
          serverName = grafana_domain;

          sslCertificate = "/var/lib/acme/${grafana_domain}/fullchain.pem";
          sslCertificateKey = "/var/lib/acme/${grafana_domain}/key.pem";
          sslTrustedCertificate = "/var/lib/acme/${grafana_domain}/chain.pem";

          forceSSL = true;
          kTLS = true;
          enableACME = true;

          quic = true;
          extraConfig = ''
            add_header Alt-Svc 'h3=":443"; ma=86400' always;
          '';

          locations."/" = {
            proxyPass = "http://unix:${config.services.grafana.settings.server.socket}";
            proxyWebsockets = true;
          };

        };

        nginx.virtualHosts."${prometheus_domain}" = {
          serverName = prometheus_domain;

          sslCertificate = "/var/lib/acme/${prometheus_domain}/fullchain.pem";
          sslCertificateKey = "/var/lib/acme/${prometheus_domain}/key.pem";
          sslTrustedCertificate = "/var/lib/acme/${prometheus_domain}/chain.pem";

          forceSSL = true;
          kTLS = true;
          enableACME = true;

          quic = true;
          extraConfig = ''
            add_header Alt-Svc 'h3=":443"; ma=86400' always;
          '';

          locations."/" = {
            proxyPass = "http://unix:${config.services.grafana.settings.server.socket}";
            proxyWebsockets = true;
          };

        };

        grafana = {
          enable = true;
          settings = {
            "auth.generic_oauth" = {
              enabled = true;
              name = "Authelia";
              icon = "signin";
              client_id = "grafana";
              client_secret = "$file__{${myLib.getSecretPath "grafana/auth/generic_oauth/client_secret"}}";
              scopes = [
                "openid"
                "profile"
                "email"
                "groups"
              ];
              empty_scopes = false;
              auth_url = "https://auth.maximizzar.org/api/oidc/authorization";
              token_url = "https://auth.maximizzar.org/api/oidc/token";
              api_url = "https://auth.maximizzar.org/api/oidc/userinfo";
              login_attribute_path = "preferred_username";
              groups_attribute_path = "groups";
              name_attribute_path = "name";
              use_pkce = true;
              # role_attribute_path = (allows to map Authelia groups with Grafana groups
              auth_style = "InHeader";
            };

            database = {
              host = "/run/postgresql";
              type = "postgres";
              user = config.services.grafana.settings.database.name;
              password = "$__file{${myLib.getSecretPath "grafana/database/password"}}";
            };

            security = {
              cookie_secure = true;
              secret_key = "$__file{${myLib.getSecretPath "grafana/security/secret_key"}}";
            };

            server = {
              protocol = "socket";
              root_url = "https://grafana.maximizzar.org/";
              enforce_domain = false;
            };

            analytics.reporting_enabled = false;
          };
        };

        prometheus = {
          enable = true;
          listenAddress = "[::1]";
          exporters = {
            fritz = {
              enable = true;
              settings = { };
              listenAddress = "[::1]";
            };
            node = {
              enable = true;
              enabledCollectors = [ "systemd" ];
              listenAddress = "[::1]";
            };
            snmp = {
              enable = true;
              configuration = {
              };
              listenAddress = "[::1]";
              environmentFile = myLib.getSecretPath "prometheus/exporters/snmp";
            };
          };

          scrapeConfigs = [
            {
              job_name = "node-exporter";
              scrape_interval = "30s";
              static_configs = [
                {
                  targets = [
                    "${exporters.node.listenAddress}:${toString exporters.node.port}"
                  ];
                }
              ];
            }
            {
              job_name = "fritz-exporter";
              scrape_interval = "60s";
              static_configs = [
                {
                  targets = [
                    "${exporters.fritz-exporter.listenAddress}:${toString exporters.fritz-exporter.port}"
                  ];
                }
              ];
            }
            {
              job_name = "snmp-exporter";
              scrape_interval = "30s";
              static_configs = [
                {
                  targets = [
                    "${exporters.snmp.listenAddress}:${toString exporters.snmp.port}"
                  ];
                }
              ];
            }
          ];
        };
      };

      # Own custom Modules
      maximizzar = {
        webServer = {
          enable = true;
          openFirewall = true;
        };

        networking.default.MACAddress = host.MACAddress;
      };

    };
}
