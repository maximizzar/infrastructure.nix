# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.vpn =
    { config, lib, ... }:
    let
      cfg = config.maximizzar.vpn;
      modules = [
        ./_exporter.nix
        ./_firewall.nix
        ./_kernelmodules.nix
        ./_wireguard.nix
      ];
    in
    {
      imports = modules;
      options.maximizzar.vpn = {
        enable = lib.mkEnableOption "VPN Overlay Network Peer";
        openFirewall = lib.mkEnableOption "Let Peers initiate connection to this server by opening its port.";
        port = lib.mkOption {
          type = lib.types.int;
          default = 51820;
        };
        ips = lib.mkOption {
          type = lib.types.listOf lib.types.str;
        };

        privateKeyFile = lib.mkOption {
          type = lib.types.str;
        };

        peers = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                };

                publicKey = lib.mkOption {
                  type = lib.types.str;
                };

                allowedIPs = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                };

                persistentKeepalive = lib.mkOption {
                  type = lib.types.int;
                  default = cfg.persistentKeepalive;
                };

                endpoint = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = cfg.endpoint;
                };

              };
            }

          );
        };

        metrics = {
          enable = lib.mkOption {
            default = config.maximizzar.metrics.enable;
            description = "NGINX protected metrics";
          };

          domain = lib.mkOption {
            type = lib.types.str;
            description = "Under which domain the hosts metrics will be exposed.";
            default = config.maximizzar.metrics.domain;
          };

        };

        persistentKeepalive = lib.mkOption {
          type = lib.types.int;
          default = 25;
        };

        endpoint = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };

    };
}
