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

      # Own custom Modules
      maximizzar = {
        networking.default.MACAddress = host.MACAddress;
      };

    };
}
