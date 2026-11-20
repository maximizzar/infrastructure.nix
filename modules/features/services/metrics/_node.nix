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
