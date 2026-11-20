# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.vpn;
in
{
  services = {
    prometheus.exporters.wireguard = lib.mkIf cfg.metrics.enable {
      enable = cfg.metrics.enable;
      withRemoteIp = true;
      latestHandshakeDelay = true;
      singleSubnetPerField = false;
    };

    nginx.virtualHosts."metrics".locations."/wireguard" = {
      proxyPass = "http://${config.services.prometheus.exporters.wireguard.listenAddress}:${toString config.services.prometheus.exporters.wireguard.port}/metrics";
    };
  };

}
