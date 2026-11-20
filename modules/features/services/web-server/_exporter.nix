# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.webServer;
in
{
  services = lib.mkIf cfg.metrics.enable {
    nginx = {
      statusPage = cfg.metrics.enable;
      virtualHosts."metrics".locations."/nginx" = {
        proxyPass = "http://${config.services.prometheus.exporters.nginx.listenAddress}:${toString config.services.prometheus.exporters.nginx.port}${config.services.prometheus.exporters.nginx.telemetryPath}";
      };
    };

    prometheus.exporters.nginx = {
      inherit (cfg.metrics) enable;
      listenAddress = "[::1]";
    };
  };
}
