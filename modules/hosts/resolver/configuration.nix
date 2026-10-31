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
    in
    {
      imports = [
        self.nixosModules.qemuVm
        self.nixosModules.containers
        self.nixosModules.resolver
      ];

      networking = {
        inherit (host) hostName domain;
        nftables.enable = true;
        firewall = {
          enable = true;

        };
      };

      # Disable resolved, we roll own dns on this machine
      services.resolved.enable = false;

      # DNS debug tooling
      environment.systemPackages = with pkgs; [
        dnsutils
        dig
      ];

      # Own custom Modules
      maximizzar = {
        resolver = {
          enable = true;
          openFirewall = true;

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
        };

        networking.default.MACAddress = host.MACAddress;
      };

    };
}
