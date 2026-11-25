# SPDX-FileCopyrightText: 2026 maximizzar <mail.maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, lib, ... }:
let
  cfg = config.maximizzar.metrics;
in
{
  services = lib.mkIf cfg.enable {
    prometheus.exporters.node = {
      enable = cfg.enable;
      listenAddress = "[::1]";
      enabledCollectors = [ "systemd" ];
    };

    nginx.virtualHosts."metrics".locations."/node" = {
      proxyPass = "http://${config.services.prometheus.exporters.node.listenAddress}:${toString config.services.prometheus.exporters.node.port}/metrics";
    };
  };
}
