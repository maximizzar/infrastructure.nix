# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.gw-genesisConfiguration =
    { inventory, ... }:
    let
      host = inventory.overlay.sites.genesis.hosts.gw;
      services_domain = "services.genesis.maximizzar.org";
    in
    {
      imports = with self.nixosModules; [
        qemuVm
        proxy
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
        # Enable various cli tools
        cliTooling = {
          enable = true;
        };

        knownHosts = {
          gitRemotes.enable = true;
          guests.enable = true;
          machines.enable = true;
        };

        proxy = {
          domain = "maximizzar.org";
          hosts = {
            authelia = {
              enable = true;
              subdomain = "auth";
              backend = {
                name = "auth";
                domain = services_domain;
                port = 9091;
              };
            };

            forgejo = {
              enable = true;
              backend = {
                domain = services_domain;
                port = 443;
              };
            };

            mealie = {
              enable = false;
              backend = {
                domain = services_domain;
                port = 443;
              };
            };

            prometheus = {
              enable = false;
              backend = {
                domain = services_domain;
                port = 443;
              };
            };

          };
        };

        networking.default.MACAddress = host.MACAddress;
      };

    };
}
