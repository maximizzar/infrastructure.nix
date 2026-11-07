# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.networkingDefault =
    { config, lib, ... }:
    let
      cfg = config.maximizzar.networking.default;
    in
    {
      options.maximizzar.networking.default = {
        enable = lib.mkEnableOption "Enable general VM Networking Configuration!";

        Bridge = lib.mkOption {
          type = lib.types.str;
          default = "br0";
          description = "Main Bridge";
        };

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
        # Ensure kernel has bridge modul loaded
        boot.kernelModules = [ "bridge" ];

        # Ensure systemd-networkd is used
        networking = {
          useNetworkd = true;
          networkmanager.enable = false;
          useDHCP = false;
        };

        systemd.network = {
          enable = true;

          netdevs."10-${cfg.Bridge}" = {
            netdevConfig = {
              Name = cfg.Bridge;
              Kind = "bridge";
              inherit (cfg) MACAddress;
            };
          };

          # Attach main interface to main bridge
          networks."20-${cfg.Interface}" = {
            matchConfig.Name = cfg.Interface;
            networkConfig.Bridge = cfg.Bridge;
          };

          networks."30-${cfg.Bridge}" = {
            matchConfig.Name = cfg.Bridge;
            networkConfig = {
              DHCP = lib.mkDefault "yes";

              IPv4Forwarding = lib.mkDefault true;
              IPv6Forwarding = lib.mkDefault true;

              IPv6AcceptRA = lib.mkDefault true;
              IPv6PrivacyExtensions = lib.mkDefault false;
              IPv6LinkLocalAddressGenerationMode = "eui64";
            };
          };

        };
      };

    };

}
