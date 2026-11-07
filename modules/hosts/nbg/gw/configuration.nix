# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.gw-nbgConfiguration =
    { config, inventory, ... }:
    let
      site = inventory.overlay.sites.nbg;
      host = site.hosts.gw;
      services_domain = "services.nbg.maximizzar.org";

      upstream_bridge = "br0";
      upstream_dummy = "dummy0";
      upstream_interface = "eth0";
    in
    {
      imports = with self.nixosModules; [
        grubBoot
        base
        networkingDefault
        gw-nbgSecrets
        sops

        self.nixosModules.inventory
        cliTooling

        vpn
      ];

      services.openssh.enable = true;
      services.qemuGuest.enable = true;

      boot.kernel.sysctl = {
        "net.ipv6.conf.all.forwarding" = "1";
      };

      networking = {
        inherit (host) hostName domain;
        nftables.enable = true;
        firewall = {
          enable = true;

        };
      };

      systemd.network = {
        # allows to use link in config by name
        links."10-${upstream_interface}" = {
          matchConfig.MACAddress = "92:00:08:2a:50:ae";

          linkConfig = {
            Name = upstream_interface;
            AlternativeName = "enx9200082a50ae";
          };
        };

        # Create dummy interface so bridge stays up
        netdevs."05-${upstream_dummy}" = {
          netdevConfig = {
            Name = upstream_dummy;
            Kind = "dummy";
          };
        };

        # Configure Bridges on L3
        networks."30-${upstream_bridge}" = {
          matchConfig.Name = "br0";
          networkConfig.DHCP = "ipv4";
          ipv6Prefixes = [
            {
              Assign = true;
              Prefix = "2a01:4f8:c2c:bd86::/64";
            }

            {
              Assign = true;
              Prefix = "fd80:3aa8:691a:fe00::/64";
            }
          ];
        };
      };

      # Own custom Modules
      maximizzar = {
        cliTooling = {
          enable = true;
          sys = true;
        };

        knownHosts = {
          gitRemotes.enable = true;
          guests.enable = true;
          machines.enable = true;
        };

        vpn = {
          enable = true;
          openFirewall = true;
          ips = [ inventory.transit.peers.nbg.address ];
          privateKeyFile = config.sops.secrets."wg/private_key".path;
          peers = [
            {
              name = "genesis";
              publicKey = inventory.transit.peers.genesis.publicKey;
              allowedIPs = [
                inventory.transit.peers.genesis.address
                inventory.overlay.sites.genesis.Prefix
              ];
            }
            {
              name = "ext1";
              publicKey = inventory.transit.peers.ext1.publicKey;
              allowedIPs = [
                inventory.transit.peers.ext1.address
                inventory.overlay.sites.ext1.Prefix
              ];
            }
            {
              name = "dev1";
              publicKey = inventory.transit.peers.dev1.publicKey;
              allowedIPs = [ inventory.transit.peers.dev1.address ];
            }
          ];
        };

        networking.default = {
          Interface = upstream_dummy;
          MACAddress = host.MACAddress;
        };
      };
    };
}
