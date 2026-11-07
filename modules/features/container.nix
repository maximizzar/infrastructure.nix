# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inputs, ... }: {
  flake.nixosModules.container = { config, lib, ... }: {
    imports = [
      self.nixosModules.base
    ];

    networking = {
      useDHCP = false;
      useNetworkd = true;
    };

    systemd.network.enable = true;
    networking.useHostResolvConf = lib.mkForce false;
    services.resolved.enable = lib.mkDefault true;

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
        UseDNS = lib.mkDefault true;
      };

      linkConfig.RequiredForOnline = "routable";
    };
  };
}
