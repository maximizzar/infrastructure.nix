{ config, lib, ... }:
let
  cfg = config.maximizzar.networking.ipForwarding;
in
{
  options.maximizzar.networking.ipForwarding.enable = lib.mkEnableOption "Allow IP Forwarding";
  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv6.conf.default.forwarding" = 1;
    };
  };
}
