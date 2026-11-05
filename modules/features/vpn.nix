# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.vpn =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.maximizzar.vpn;
    in
    {
      options.maximizzar.vpn = {
        enable = lib.mkEnableOption "VPN Overlay Network Peer";
        openFirewall = lib.mkEnableOption "";
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

                persistentKeepalive = lib.mkOption {
                  type = lib.types.int;
                  default = cfg.persistentKeepalive;
                };

                endpoint = lib.mkOption {
                  type = lib.types.str;
                  default = cfg.endpoint;
                };

              };
            }

          );
        };

        persistentKeepalive = lib.mkOption {
          type = lib.types.int;
          default = 25;
        };

        endpoint = lib.mkOption {
          type = lib.types.str;
        };
      };

      config = lib.mkIf cfg.enable {
        networking = {
          firewall.allowedUDPPorts = lib.mkIf lib.openFirewall [
            cfg.port
          ];

          wireguard = {
            inherit (cfg) enable;

            interfaces.wg0 = {
              inherit (cfg) ips privateKeyFile;

              allowedIPsAsRoutes = true;
              listenPort = cfg.port;

              peers = map (peer: {
                inherit (peer)
                  publicKey
                  allowedIPs
                  persistentKeepalive
                  endpoint
                  ;
                name = "Site: ${peer.name}";
              }) cfg.peers;
            };
          };

        };

      };
    };
}
