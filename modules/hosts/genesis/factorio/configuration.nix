# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.factorioConfiguration =
    {
      inventory,
      ...
    }:
    let
      host = inventory.overlay.sites.genesis.hosts.factorio;
    in
    {

      imports = with self.nixosModules; [
        qemuVm
        factorio
      ];

      networking = {
        inherit (host) hostName domain;
        nftables.enable = true;
        firewall = {
          enable = true;

        };
      };

      # Own custom Modules
      maximizzar = {
        factorio = {
          enable = true;
          openFirewall = true;
        };

        networking.default.MACAddress = host.MACAddress;
      };

    };
}
