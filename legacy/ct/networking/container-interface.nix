# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.networking.containerInterface;
in
{
  options.maximizzar.modules.networking.containerInterface = {
    enable = lib.mkEnableOption "containerInterface";
    dns = lib.mkEnableOption "set dns service";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      useDHCP = false;
      useNetworkd = true;
    };

    # Use own resolved in container
    systemd.network.enable = true;
    networking.useHostResolvConf = lib.mkForce false;
    services.resolved.enable = cfg.dns;

    # Configure main interface
    systemd.network.networks."10-eth0" = {
      matchConfig.Name = "eth0";

      networkConfig = {
        IPv6AcceptRA = true;
        IPv6PrivacyExtensions = false;
        IPv6LinkLocalAddressGenerationMode = "eui64";
      };

      ipv6AcceptRAConfig = {
        UseAutonomousPrefix = true;
        UseDNS = cfg.dns;
      };

      linkConfig.RequiredForOnline = "routable";
    };
  };
}
