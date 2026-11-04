# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.gw-genesisConfiguration =
    {
      config,
      inventory,
      pkgs,
      ...
    }:
    let
      site = inventory.overlay.sites.genesis;
      host = site.hosts.gw;
      services_domain = "services.genesis.maximizzar.org";

      upstream_interface = "br0";

      exec_bridge = "br3-exec";
      exec_interface = "ens21";

      dmz_bridge = "br1-dmz";
      dmz_interface = "ens19";

      srv_bridge = "br2-srv";
      srv_interface = "ens20";
    in
    {
      imports = with self.nixosModules; [
        qemuVm
        gw-genesisSecrets
        dnsdist
        proxy
      ];

      environment.systemPackages = with pkgs; [
        dnsutils
        dig
      ];

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
        # Create L2 Bridge Interfaces
        netdevs = {
          "10-${exec_bridge}" = {
            netdevConfig = {
              Name = exec_bridge;
              Kind = "bridge";
              inherit (host.bridges.exec) MACAddress;
            };
          };

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
          "20-${exec_interface}" = {
            matchConfig.Name = exec_interface;
            networkConfig.Bridge = exec_bridge;
          };

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
          "30${upstream_interface}" = {
            dhcpV6Config = {
              PrefixDelegationHint = "::/62";
            };
          };

          "30-${exec_bridge}" = {
            matchConfig.Name = exec_bridge;
            networkConfig = {
              IPv6Forwarding = true;

              # Address Generation
              IPv6AcceptRA = false;
              IPv6PrivacyExtensions = false;
              IPv6LinkLocalAddressGenerationMode = "eui64";

              IPv6SendRA = true;
              DHCPPrefixDelegation = true;
            };

            dhcpPrefixDelegationConfig = {
              UplinkInterface = upstream_interface;
              SubnetId = "0";
              Announce = true;
            };

            ipv6SendRAConfig = {
              DNS = host.bridges.exec.Ipv6Address;
              EmitDNS = true;
              OtherInformation = true;
            };

            # Static ULA config
            ipv6Prefixes = [
              {
                Assign = true;
                Prefix = site.networks.exec.Prefix;
              }
            ];

          };

          "30-${dmz_bridge}" = {
            matchConfig.Name = dmz_bridge;
            networkConfig = {
              IPv6Forwarding = true;

              # Address Generation
              IPv6AcceptRA = false;
              IPv6PrivacyExtensions = false;
              IPv6LinkLocalAddressGenerationMode = "eui64";

              IPv6SendRA = true;
              DHCPPrefixDelegation = true;
            };

            dhcpPrefixDelegationConfig = {
              UplinkInterface = upstream_interface;
              SubnetId = "1";
              Announce = true;
            };

            ipv6SendRAConfig = {
              DNS = host.bridges.dmz.Ipv6Address;
              EmitDNS = true;
              OtherInformation = true;
            };

            # Static ULA config
            ipv6Prefixes = [
              {
                Assign = true;
                Prefix = site.networks.dmz.Prefix;
              }
            ];

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
              DHCPPrefixDelegation = true;
            };

            dhcpPrefixDelegationConfig = {
              UplinkInterface = upstream_interface;
              SubnetId = "2";
              Announce = true;
            };

            ipv6SendRAConfig = {
              DNS = host.bridges.srv.Ipv6Address;
              EmitDNS = true;
              OtherInformation = true;
            };

            # Static ULA config
            ipv6Prefixes = [
              {
                Assign = true;
                Prefix = site.networks.srv.Prefix;
              }
            ];

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
          backend = inventory.overlay.sites.genesis.hosts.resolver.Ipv6Address;
          acl = [
            "192.168.178.0/24"
            inventory.overlay.Prefix
          ];
        };

        proxy = {
          enable = true;
          openFirewall = true;
          domain = "maximizzar.org";
          environmentFile = config.sops.secrets.ionos-acme.path;

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
