# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.networking.ipForwarding;
in
{
  options.maximizzar.networking.ipForwarding = {
    enable = lib.mkEnableOption "Enable IP Forwarding on an Interface!";

    interface = lib.mkOption {
      type = lib.types.str;
      default = "ens18";
      description = "Wan Interface";
    };

    PrefixDelegationHint = lib.mkOption {
      type = lib.types.str;
      default = "::/64";
      description = "What Prefixsize to request from upstream router";
    };

  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = 1;
    };

    systemd.network.networks."10-${cfg.interface}" = {
      matchConfig.Name = cfg.interface;
      networkConfig.DHCP = "ipv6";

      dhcpV6Config.PrefixDelegationHint = cfg.PrefixDelegationHint;
    };

  };
}
