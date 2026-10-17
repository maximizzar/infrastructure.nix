# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.networking.containerNetworking;
in
{
  options.maximizzar.networking.containerNetworking = {
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

    ulaPrefix = lib.mkOption {
      type = lib.types.str;
      default = [ ];
      description = "Extra static Ipv6 Prefixes for the Bridge Interface!";
    };

    mac = lib.mkOption {
      type = lib.types.str;
      description = "Bridge-Interface MAC-Address";
    };

    DNS = lib.mkOption {
      type = lib.types.str;
      default = "fd80:3aa8:691a:ff03:be24:11ff:fe49:25c8";
      description = "DNS for containers";
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

      linkConfig = {
        MACAddress = cfg.mac;
      };

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

      # Set host as DNS for Container-network
      ipv6SendRAConfig = {
        DNS = cfg.DNS;
        EmitDNS = true;
        OtherInformation = true;
      };

      # Static ULA config
      ipv6Prefixes = [
        {
          Assign = true;
          Prefix = cfg.ulaPrefix;
        }
      ];
    };
  };
}
