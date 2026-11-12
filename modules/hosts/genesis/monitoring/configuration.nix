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

      security.acme.certs."${grafana_domain}" = {
        domain = grafana_domain;
        webroot = "/var/lib/acme/acme-challenge";
        postRun = "systemctl reload nginx";
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
          exporters = {
            fritz = {
              enable = false;
              settings = { };
              listenAddress = "[::1]";
            };
            node = {
              enable = true;
              enabledCollectors = [ "systemd" ];
              listenAddress = "[::1]";
            };
          };

          scrapeConfigs = [
            {
              job_name = "self";
              static_configs = [
                {
                  targets = [
                    "${config.services.prometheus.exporters.node.listenAddress}:${toString config.services.prometheus.exporters.node.port}"
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
