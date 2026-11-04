# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inventory, ... }: {
  flake.nixosModules.runnerConfiguration =
    {
      config,
      lib,
      ...
    }:
    let
      host = inventory.overlay.sites.genesis.hosts.runner;
    in
    {
      imports = with self.nixosModules; [
        qemuVm
        forgejoRunner
      ];

      disko.devices.disk.main = {
        imageSize = "16G";
        content.partitions.root.priority = 3;
      };

      networking = {
        inherit (host) hostName domain;
        nftables.enable = true;
        firewall = {
          enable = true;

        };
      };

      # Own custom Modules
      maximizzar = {
        # Enable various cli tools
        cliTooling = {
          enable = true;
        };

        knownHosts = {
          gitRemotes.enable = true;
          guests.enable = true;
          machines.enable = true;
        };

        forgejoRunner = {
          enable = true;
          url = "https://forgejo.maximizzar.org";
          instances.worker1 = {
            capacity = 2;
            tokenFile = ""; # TODO (sops-nix)
          };
        };

        networking.default.MACAddress = host.MACAddress;
      };
    };
}
