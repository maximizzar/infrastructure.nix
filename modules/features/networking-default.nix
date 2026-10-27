# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.networkingDefault =
    { config, lib, ... }:
    let
      cfg = config.maximizzar.networking.default;
      br = "br0";
    in
    {
      options.maximizzar.networking.default = {
        enable = lib.mkEnableOption "Enable general VM Networking Configuration!";

        Interface = lib.mkOption {
          type = lib.types.str;
          default = "ens18";
          description = "Main Interface";
        };

        MACAddress = lib.mkOption {
          type = lib.types.str;
          description = "Main Bridge MACAddress";
        };

      };

      config = lib.mkIf cfg.enable {

        # Ensure systemd-networkd is used
        networking = {
          useNetworkd = true;
          networkmanager.enable = false;
          useDHCP = false;
        };

        systemd.network = {
          enable = true;

          netdevs."10-${br}" = {
            netdevConfig = {
              Name = br;
              Kind = "bridge";
              MACAddress = cfg.MACAddress;
            };
          };

          # Attach main interface to main bridge
          networks."20-${cfg.Interface}" = {
            matchConfig.Name = cfg.Interface;
            networkConfig.Bridge = br;
          };

          networks."30-${br}" = {
            matchConfig.Name = br;
            networkConfig = {
              DHCP = "yes";
              IPv6AcceptRA = lib.mkDefault true;
              IPv6PrivacyExtensions = lib.mkDefault false;
              IPv6LinkLocalAddressGenerationMode = "eui64";
            };
          };

        };
      };

    };

}
