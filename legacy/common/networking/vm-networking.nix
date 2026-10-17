# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.networking.vmNetworking;
in
{
  options.maximizzar.networking.vmNetworking = {
    enable = lib.mkEnableOption "Enable general VM Interface Configuration!";

    interface = lib.mkOption {
      type = lib.types.str;
      default = "ens18";
      description = "Interface name";
    };

  };

  config = lib.mkIf cfg.enable {
    networking = {
      useDHCP = false;
      useNetworkd = true;
    };

    systemd.network.networks."10-${cfg.interface}" = {
      matchConfig.Name = cfg.interface;

      networkConfig = {
        IPv6AcceptRA = true;
        IPv6PrivacyExtensions = false;
        IPv6LinkLocalAddressGenerationMode = "eui64";
      };

    };
  };
}
