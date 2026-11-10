# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.gw-nbgConfiguration =
    {
      config,
      pkgs,
      inventory,
      ...
    }:
    let
      site = inventory.overlay.sites.nbg;
      host = site.hosts.gw;
      services_domain = "services.genesis.maximizzar.org";

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
        containers

        cliTooling

        vpn
        dnsdist
        proxy
      ];

      environment.systemPackages = with pkgs; [
        dnsutils
      ];

      services.openssh.enable = true;
      services.qemuGuest.enable = true;

      users.users.maximizzar.enable = true;
      security.sudo.wheelNeedsPassword = false;

      boot.kernelModules = [ "dummy" ];
      boot.kernel.sysctl = {
        "net.ipv6.conf.all.forwarding" = "1";
      };

      networking = {
        inherit (host) hostName domain;
        nameservers = [ inventory.overlay.sites.nbg.hosts.gw.Ipv6Address ];
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

        networks."30-${upstream_interface}" = {
          matchConfig.Name = upstream_interface;

          linkConfig = {
            RequiredForOnline = "routable";
            RequiredFamilyForOnline = "ipv6";
          };

          networkConfig = {
            Description = "Hetzner Uplink";
            DHCP = "ipv4";
            IPv6PrivacyExtensions = false;
            IPv6AcceptRA = false;
          };

          routes = [
            {
              Gateway = "fe80::1";
              GatewayOnLink = true;
            }
          ];

          dhcpV4Config.UseDNS = false;
          ipv6AcceptRAConfig.UseDNS = false;
        };

        # Configure Bridges on L3
        networks."30-${upstream_bridge}" = {
          matchConfig.Name = upstream_bridge;
          networkConfig = {
            DHCP = "ipv4";

            IPv6SendRA = true;
            IPv6Forwarding = true;
          };

          ipv6SendRAConfig = {
            DNS = config.networking.nameservers;
            EmitDNS = true;
            OtherInformation = true;
          };

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

        containers = {
          pforgejo = {
            localMacAddress = host.containers.pforgejo.MACAddress;
            modules = [
              {
                networking.firewall.allowedTCPPorts = [ 22 ];
                services.nginx = {
                  enable = true;
                  streamConfig = ''
                    server {
                      listen [::]:22;

                      proxy_connect_timeout 10s;
                      proxy_timeout 20s;

                      proxy_pass [${inventory.overlay.sites.genesis.hosts.forgejo.Ipv6Address}]:22;
                    }
                  '';

                };
              }
            ];
          };
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

        dnsdist = {
          enable = true;
          openFirewall = true;
          backend = inventory.overlay.sites.genesis.hosts.resolver.Ipv6Address;
          acl = [ inventory.overlay.sites.nbg.Prefix ];
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

            navidrome = {
              enable = true;
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

        networking.default = {
          enable = true;
          Interface = upstream_dummy;
          MACAddress = host.MACAddress;
        };
      };
    };
}
