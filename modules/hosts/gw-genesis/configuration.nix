# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.gw-genesisConfiguration =
    { inventory, pkgs, ... }:
    let
      host = inventory.overlay.sites.genesis.hosts.gw;
      services_domain = "services.genesis.maximizzar.org";

      upstream_interface = "br0";

      dmz_bridge = "br-dmz";
      dmz_interface = "ens19";

      srv_bridge = "br-srv";
      srv_interface = "ens20";
    in
    {
      imports = with self.nixosModules; [
        qemuVm
        dnsdist
        proxy
      ];

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

      systemd.network = {
        # Create L2 Bridge Interfaces
        netdevs = {
          "10-${dmz_bridge}" = {
            netdevConfig = {
              Name = dmz_bridge;
              Kind = "bridge";
              inherit (host.bridges.dmz) MACAddress;
            };
          };

          "10-${srv_bridge}" = {
            netdevConfig = {
              Name = srv_bridge;
              Kind = "bridge";
              inherit (host.bridges.srv) MACAddress;
            };
          };
        };

        # Attach interface to bridge
        networks = {
          "20-${dmz_interface}" = {
            matchConfig.Name = dmz_interface;
            networkConfig.Bridge = dmz_bridge;
          };

          "20-${srv_interface}" = {
            matchConfig.Name = srv_interface;
            networkConfig.Bridge = srv_bridge;
          };
        };

        # Configure Bridges on L3
        networks = {
          "30-${dmz_bridge}" = {
            matchConfig.Name = dmz_bridge;
            networkConfig = {
              IPv6Forwarding = true;

              # Address Generation
              IPv6AcceptRA = false;
              IPv6PrivacyExtensions = false;
              IPv6LinkLocalAddressGenerationMode = "eui64";

              IPv6SendRA = true;
              DHCP = "ipv6";
              DHCPPrefixDelegation = true;
            };

            dhcpPrefixDelegationConfig = {
              UplinkInterface = upstream_interface;
              SubnetId = "0";
              Announce = true;
            };

          };

          "30-${srv_bridge}" = {
            matchConfig.Name = srv_bridge;
            networkConfig = {
              IPv6Forwarding = true;

              # Address Generation
              IPv6AcceptRA = false;
              IPv6PrivacyExtensions = false;
              IPv6LinkLocalAddressGenerationMode = "eui64";

              IPv6SendRA = true;
              DHCP = "ipv6";
              DHCPPrefixDelegation = true;
            };

            dhcpPrefixDelegationConfig = {
              UplinkInterface = upstream_interface;
              SubnetId = "1";
              Announce = true;
            };

          };
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

        dnsdist = {
          enable = true;
          openFirewall = true;
          backend = "2620:fe::fe";
          #backend = inventory.overlay.sites.genesis.hosts.resolver.Ipv6Address;
          acl = "::/0";
          #acl = inventory.overlay.sites.genesis.Prefix;
        };

        proxy = {
          enable = false;
          openFirewall = true;
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
