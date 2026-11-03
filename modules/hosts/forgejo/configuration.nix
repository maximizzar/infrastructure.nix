# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inventory, ... }: {
  flake.nixosModules.forgejoConfiguration =
    {
      config,
      lib,
      ...
    }:
    let
      host = inventory.overlay.sites.genesis.hosts.forgejo;
    in
    {
      imports = with self.nixosModules; [
        qemuVm
        forgejo
        forgejoSecrets
      ];

      disko.devices.disk.main = {
        imageSize = "16G";
        content.partitions.root.priority = 3;
      };

      # Add Partitons for git repositories
      disko.devices.disk.main.content.partitions = {
        repositories = {
          priority = 2;
          name = "repositories";
          size = "8G";

          content = {
            type = "filesystem";
            format = "ext4";
            extraArgs = [
              "-L"
              "repos"
            ];
            mountpoint = "/mnt/repositories";
            mountOptions = [ "noatime" ];
          };
        };
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

        forgejo = {
          enable = true;
          openFirewall = true;
          inherit (config.networking) fqdn;

          passwordFile = config.sops.secrets."forgejo_database/password".path;
        };

        networking.default.MACAddress = host.MACAddress;
      };
    };
}
