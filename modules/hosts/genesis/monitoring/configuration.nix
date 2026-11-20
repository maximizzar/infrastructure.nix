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
      wakapi_domain = "wakapi." + host.hostName + "." + host.domain;
      dashboards = {
        node-exporter = {
          id = 1860;
          revision = 45;
          hash = "sha256-GExrdAnzBtp1Ul13cvcZRbEM6iOtFrXXjEaY6g6lGYY=";
        };

        prometheus = {
          id = 3662;
          revision = 2;
          hash = "sha256-+nsi8/dYNvGVGV+ftfO1gSAQbO5GpZwW480T5mHMM4Q=";
        };

        fritz-exporter = {
          id = 17751;
          revision = 1;
          hash = "sha256-foc00LtcBTXOzvwyddJO0QJkCP82bUXa5iMuQmHqKcg=";
        };
      };

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
        "${wakapi_domain}" = {
          domain = wakapi_domain;
          webroot = "/var/lib/acme/acme-challenge";
          postRun = "systemctl reload nginx";
        };

      };

      users.users."${config.services.nginx.user}".extraGroups = [
        "grafana"
        "wakapi"
      ];

      services = {
        postgresql = {
          enable = true;
          enableTCPIP = false;
          ensureDatabases = [
            config.services.grafana.settings.database.name
            config.services.wakapi.database.name
          ];

          ensureUsers = [
            {
              name = config.services.grafana.settings.database.user;
              ensureDBOwnership = true;
            }
            {
              name = config.services.wakapi.database.user;
              ensureDBOwnership = true;
            }
          ];
        };

        nginx = {
          serverNamesHashBucketSize = 256;
          virtualHosts."${grafana_domain}" = {
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
            proxyPass = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
            proxyWebsockets = true;
          };

        };

        nginx.virtualHosts."${wakapi_domain}" = {
          serverName = wakapi_domain;

          sslCertificate = "/var/lib/acme/${wakapi_domain}/fullchain.pem";
          sslCertificateKey = "/var/lib/acme/${wakapi_domain}/key.pem";
          sslTrustedCertificate = "/var/lib/acme/${wakapi_domain}/chain.pem";

          forceSSL = true;
          kTLS = true;
          enableACME = true;

          quic = true;
          extraConfig = ''
            add_header Alt-Svc 'h3=":443"; ma=86400' always;
          '';

          locations."/" = {
            proxyPass = "http://unix:${config.services.wakapi.settings.server.listen_socket}";
            proxyWebsockets = true;
          };

        };

        grafana = {
          enable = true;
          provision = {
            enable = config.grafana.enable;
            datasources.settings = {
              prune = true;
              datasources = [
                {
                  name = "Prometheus";
                  uid = "prometheus";
                  type = "prometheus";
                  url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
                  isDefault = true;
                  editable = false;
                }
              ];
            };
            dashboards.settings.providers = [
              {
                name = "NixOS Dashboards";
                type = "file";
                disableDeletion = true;
                allowUiUpdates = false;

                options.path = myLib.mkGrafanaDashboardsBundle (myLib.fetchGrafanaDashboards dashboards);
              }
            ];
          };
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

            users = {
              default_theme = "system";

              # Viewers can access and use Explore and perform temporary edits on panels in dashboards they have
              # access to. They cannot save their changes.
              viewers_can_edit = false;
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
              settings = {
                devices = [
                  {
                    name = "Fritz!Box 7530 AX";
                    hostname = "[64:ff9b::192.168.178.1]";
                    username = "prometheus";
                    password_file = myLib.getSecretPath "prometheus/exporters/fritz";
                    host_info = true;
                  }
                ];
                log_level = "WARNING";
              };
              # Because python sucks no []
              listenAddress = "::1";
            };
            node = {
              enable = true;
              enabledCollectors = [
                "systemd"
                "processes"
              ];
              listenAddress = "[::1]";
            };
            snmp = {
              enable = false;
              configuration = {
              };
              listenAddress = "[::1]";
              environmentFile = myLib.getSecretPath "prometheus/exporters/snmp";
            };
          };

          scrapeConfigs = [
            {
              job_name = "node";
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
              job_name = "node-https";
              scrape_interval = "15s";
              scrape_timeout = "5s";
              metrics_path = "/node";

              scheme = "https";

              static_configs = [
                {
                  targets = [
                    "metrics.${inventory.overlay.sites.nbg.hosts.gw.hostName}.${inventory.overlay.sites.nbg.hosts.gw.domain}"
                  ];
                }
              ];

            }
            {
              job_name = "fritz-exporter";
              scrape_interval = "60s";
              scrape_timeout = "20s";
              static_configs = [
                {
                  targets = [
                    # Because python still sucks [] now have to go here!
                    "[${exporters.fritz.listenAddress}]:${toString exporters.fritz.port}"
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

        wakapi = {
          enable = true;
          settings = {
            server = {
              listen_ipv4 = "-";
              listen_ipv6 = "-";
              listen_socket = "/run/wakapi";
              listen_socket_mode = 0660;

              public_url = "wakapi.monitoring.services.genesis.maximizzar.org";
              # public_url = "https://wakapi.maximizzar.org";
            };

            app = {
              leaderboard_enabled = true;
              leaderboard_scope = "14_days";
              leaderboard_require_auth = true;
            };

            db = {
              host = "/run/postgresql";
              port = 5432;
              user = "wakapi";
              name = "wakapi";
              dialect = "postgres";
            };

            security = {
              disable_local_auth = true;
              invite_codes = false;
              disable_frontpage = false;
              expose_metrics = true;
            };

          };

          database = {
            dialect = "postgres";
            createLocally = true;
          };
          environmentFiles = [
            (myLib.getSecretPath "wakapi/environmentFiles/WAKAPI_PASSWORD_SALT")
            (myLib.getSecretPath "wakapi/environmentFiles/WAKAPI_DB_PASSWORD")
          ];
        };

      };

      # Own custom Modules
      maximizzar.networking.default.MACAddress = host.MACAddress;
    };
}
