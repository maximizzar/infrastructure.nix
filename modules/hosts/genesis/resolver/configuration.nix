# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.resolverConfiguration =
    {
      pkgs,
      inventory,
      ...
    }:
    let
      host = inventory.overlay.sites.genesis.hosts.resolver;
      modules = with self.nixosModules; [
        qemuVm
        containers
        resolver
      ];
    in
    {
      imports = modules;

      # DNS debug tooling
      environment.systemPackages = with pkgs; [
        dnsutils
        dig
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
        resolver = {
          enable = true;
          openFirewall = true;
          blocklists = true;

          forward_zones = [
            {
              zone = "maximizzar.org";
              forwarders = [
                "[${host.containers.nameserver.Ipv6Address}]:53"
              ];
            }

            {
              zone = "maximizzar.io";
              forwarders = [
                "[fd80:3aa8:691a:ff03:fcd4:d2ff:fe1d:db65]:53"
              ];
            }

          ];
        };

        containers = {
          nameserver = {
            localMacAddress = host.containers.nameserver.MACAddress;
            modules = [
              self.nixosModules.nameserver
            ];
          };

          resolver64 = {
            localMacAddress = host.containers.resolver64.MACAddress;
            modules = [
              self.nixosModules.resolver
              {
                maximizzar.resolver = {
                  enable = true;
                  openFirewall = true;
                  blocklists = true;

                  forward_zones = [
                    {
                      zone = "maximizzar.org";
                      forwarders = [
                        "[${host.containers.nameserver.Ipv6Address}]:53"
                      ];
                    }

                    {
                      zone = "maximizzar.io";
                      forwarders = [
                        "[fd80:3aa8:691a:ff03:fcd4:d2ff:fe1d:db65]:53"
                      ];
                    }

                  ];
                };
                services.pdns-recursor.settings.recursor.dns64_prefix = "64:ff9b::/96";
              }
            ];
          };

        };

        networking.default.MACAddress = host.MACAddress;
      };

    };
}
