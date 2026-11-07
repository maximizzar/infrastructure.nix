# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.navidromeConfiguration =
    {
      config,
      inventory,
      ...
    }:
    let
      host = inventory.overlay.sites.genesis.hosts.navidrome;
    in
    {

      imports = with self.nixosModules; [
        qemuVm
        navidromeSecrets
        navidrome
      ];

      fileSystems."/media/music" = {
        device = "music";
        fsType = "virtiofs";
        options = [
          "ro"
          "nofail"
        ];
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
        navidrome = {
          enable = true;
          openFirewall = true;
          environmentFile = config.sops.secrets.navidrome_env.path;
        };

        networking.default.MACAddress = host.MACAddress;
      };

    };
}
