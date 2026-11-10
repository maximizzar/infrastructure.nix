# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.opencloudConfiguration =
    { config, inventory, ... }:
    let
      host = inventory.overlay.sites.genesis.hosts.opencloud;
      modules = with self.nixosModules; [
        qemuVm
        opencloud
      ];
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
        knownHosts = {
          gitRemotes.enable = true;
          guests.enable = true;
          machines.enable = true;
        };

        opencloud = {
          enable = true;
          openFirewall = true;
          domain = config.networking.domain + ":9200";
        };

        networking.default.MACAddress = host.MACAddress;
      };

      users.users.maximizzar.enable = true;
    };
}
