# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# hosts/core/gateway.nix
{ self, inputs, ... }: let
    net = inputs.self.network;

    wanInterface = "ens18";
    lanInterface = "ens19";

in {
    # IPv6 Forwarding
    boot.kernel.sysctl = {
        "net.ipv6.conf.all.forwarding" = 1;
        "net.ipv6.conf.default.forwarding" = 1;
    };

    networking = {
        hostName = "gateway";
        firewall.enable = false;
        useNetworkd = true;
    };

    systemd.network = {
        enable = true;

        config.networkConfig = {
            IPv6PrivacyExtensions = false;
        };

        # WAN Interface
        networks."10-wan" = {
            matchConfig.Name = wanInterface;
            networkConfig = {
                IPv6AcceptRA = true;
                IPv6SendRA = true;
                DHCP = "ipv6";
                IPv6Forwarding = "yes";

                IPv6PrivacyExtensions = false;
            };

            dns = [
                "fd80:3aa8:691a:20:be24:11ff:fec9:4372#ns-primary.core.prod.maximizzar.org"
                "fd80:3aa8:691a:20:be24:11ff:fe3b:7814ns-secondary.core.prod.maximizzar.org"
            ];

            dhcpV6Config = {
                PrefixDelegationHint = "::/60";
                WithoutRA = "solicit";
            };

            # announce Server Prefix into upstream LAN
            ipv6Prefixes = [{
                Prefix = "fd80:3aa8:691a::/48";

                # Don't configure WAN interface with IP from Prefix
                OnLink = false;
                Assign = false;
            }];

            ipv6RoutePrefixes = [{
                Route = "fd80:3aa8:691a::/48";
            }];
        };

        # LAN Interface
        networks."20-lan" = {
            matchConfig.Name = lanInterface;
            networkConfig = {
                VLAN = [
                    "vlan${toString net.subnets.management.vlan}"
                    "vlan${toString net.subnets.core.vlan}"
                    "vlan${toString net.subnets.vc.vlan}"
                    "vlan${toString net.subnets.web.vlan}"
                ];
            };
        };

        netdevs = {
            "vlan${toString net.subnets.management.vlan}" = {
                netdevConfig = {
                  Kind = "vlan";
                  Name = "vlan${toString net.subnets.management.vlan}";
                };
                vlanConfig.Id = net.subnets.management.vlan;
            };

            "vlan${toString net.subnets.core.vlan}" = {
                netdevConfig = {
                  Kind = "vlan";
                  Name = "vlan${toString net.subnets.core.vlan}";
                };
                vlanConfig.Id = net.subnets.core.vlan;
            };

            "vlan${toString net.subnets.vc.vlan}" = {
                netdevConfig = {
                  Kind = "vlan";
                  Name = "vlan${toString net.subnets.vc.vlan}";
                };
                vlanConfig.Id = net.subnets.vc.vlan;
            };

            "vlan${toString net.subnets.web.vlan}" = {
                netdevConfig = {
                  Kind = "vlan";
                  Name = "vlan${toString net.subnets.web.vlan}";
                };
                vlanConfig.Id = net.subnets.web.vlan;
            };
        };

        # VLAN Networks wtih IPv6 and Router Advertisements
        networks."30-vlan-management" = {
            matchConfig.Name = "vlan${toString net.subnets.management.vlan}";
            address = [ "${net.subnets.management.gateway}/${toString net.subnets.management.prefixLength}" ];
            networkConfig = {
                IPv6SendRA = false;
                DHCPServer = false;
            };

            ipv6SendRAConfig = {
                RouterLifetimeSec = 1800;
                EmitDNS = false;
                DNS = net.subnets.management.gateway;
            };

            ipv6Prefixes = [{
                Prefix = net.subnets.management.cidr;
            }];
        };

        networks."31-vlan-core" = {
            matchConfig.Name = "vlan${toString net.subnets.core.vlan}";
            address = [ "${net.subnets.core.gateway}/${toString net.subnets.core.prefixLength}" ];
            networkConfig = {
                IPv6SendRA = true;
                DHCPServer = false;
                DHCPPrefixDelegation = true;
                IPv6AcceptRA = false;
            };

            ipv6PrefixDelegationConfig = {
                SubnetId = 1;

                OnLink = false;
                Assign = false;

                Announce = true;
            };

            ipv6SendRAConfig = {
                RouterLifetimeSec = 1800;
                EmitDNS = false;
                DNS = net.subnets.core.gateway;
            };

            ipv6Prefixes = [{
                Prefix = net.subnets.core.cidr;
            }];
        };

        networks."32-vlan-vc" = {
            matchConfig.Name = "vlan${toString net.subnets.vc.vlan}";
            address = [ "${net.subnets.vc.gateway}/${toString net.subnets.vc.prefixLength}" ];
            networkConfig = {
                IPv6SendRA = true;
                DHCPServer = false;
                DHCPPrefixDelegation = true;
                IPv6AcceptRA = false;
            };

            ipv6SendRAConfig = {
                RouterLifetimeSec = 1800;
                EmitDNS = false;
                DNS = net.subnets.vc.gateway;
            };

            ipv6Prefixes = [{
                Prefix = net.subnets.vc.cidr;
            }];
        };

        networks."33-vlan-web" = {
            matchConfig.Name = "vlan${toString net.subnets.web.vlan}";
            address = [ "${net.subnets.web.gateway}/${toString net.subnets.web.prefixLength}" ];
            networkConfig = {
                IPv6SendRA = true;
                DHCPServer = false;
                DHCPPrefixDelegation = true;
                IPv6AcceptRA = false;
            };

            ipv6SendRAConfig = {
                RouterLifetimeSec = 1800;
                EmitDNS = false;
                DNS = net.subnets.web.gateway;
            };

            ipv6Prefixes = [{
                Prefix = net.subnets.web.cidr;
            }];
        };
    };
}
