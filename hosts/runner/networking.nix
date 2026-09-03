# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.networking.containerNetwork;
in
{
  options.maximizzar.networking.containerNetwork = {
    enable = lib.mkEnableOption "Enable Network config for nixos containers";
    interface = lib.mkOption {
      type = lib.types.str;
      default = "br-container";
      description = "Interface name";
    };

    upstreamInterface = lib.mkOption {
      type = lib.types.str;
      default = "ens18";
      description = "Upstream interface";
    };

    subnetId = lib.mkOption {
      type = lib.types.str;
      default = "0";
      description = "Subnet Id for containerNetwork";
    };

    mac = lib.mkOption {
      type = lib.types.str;
      description = "Bridge-Interface MAC-Address";
    };
  };

  config = lib.mkIf cfg.enable {

    # L2 Bridge for containers
    systemd.network.netdevs."20-${cfg.interface}" = {
      netdevConfig = {
        Name = "${cfg.interface}";
        Kind = "bridge";
      };
    };

    # L3 Bridge for containers
    systemd.network.networks."20-${cfg.interface}" = {
      matchConfig.Name = cfg.interface;

      networkConfig = {
        # Address Generation
        IPv6AcceptRA = "yes";
        IPv6PrivacyExtensions = false;
        IPv6LinkLocalAddressGenerationMode = "eui64";

        ConfigureWithoutCarrier = true;
        IPv6SendRA = true;
        DHCPPrefixDelegation = true;
      };

      dhcpPrefixDelegationConfig = {
        UplinkInterface = cfg.upstreamInterface;
        SubnetId = cfg.subnetId;
        Announce = true;
      };
    };
  };

  networking.useNetworkd = true;

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # WAN
  systemd.network.networks."10-ens18" = {
    matchConfig.Name = "ens18";

    networkConfig = {
      IPv6AcceptRA = true;
      DHCP = "ipv6";

      # DHCPv6-PD auf dem Upstream aktivieren
      DHCPPrefixDelegation = true;
    };
  };

}
