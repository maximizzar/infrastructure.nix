# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.monitoringConfiguration =
    {
      config,
      inventory,
      ...
    }:
    let
      host = inventory.overlay.sites.genesis.hosts.monitoring;
      modules = with self.nixosModules; [ qemuVm ];

      grafana_domain = "grafana." + host.domain;
      prometheus_domain = "prometheus." + host.domain;
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
        grafana = {
          domain = grafana_domain;
          webroot = "/var/lib/acme/acme-challenge";
        };
        prometheus = {
          domain = prometheus_domain;
          webroot = "/var/lib/acme/acme-challenge";
        };
      };

      services = {
        postgresql = {
          enable = true;
          ensureDatabases = [ config.services.grafana.settings.database.name ];
          ensureUsers = [ { name = config.services.grafana.settings.database.user; } ];
        };

        nginx.virtualHosts = {
          "${grafana_domain}" = {
            locations."/" = {
              proxyPass = "http://${config.services.grafana.settings.server.socket}";
              proxyWebsockets = true;
            };
          };

          "${prometheus_domain}" = {

          };
        };

        grafana = {
          enable = true;
          settings = {
            database = {
              type = "postgres";
              host = "/run/postgresql";
              user = config.services.grafana.settings.database.name;
            };

            server = {
              protocol = "socket";
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
        networking.default.MACAddress = host.MACAddress;
      };

    };
}
