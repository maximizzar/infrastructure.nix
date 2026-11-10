# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.dnsdist =
    { config, lib, ... }:
    let
      cfg = config.maximizzar.dnsdist;
    in
    {
      options.maximizzar.dnsdist = {
        enable = lib.mkEnableOption "Enable DNSDist service";
        openFirewall = lib.mkEnableOption "Open Ports 53 (TCP) and 53 UDP";

        backend = lib.mkOption {
          type = lib.types.str;
        };

        backend64 = lib.mkOption {
          type = lib.types.str;
          default = cfg.backend;
        };

        nat64Networks = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        acl = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of IP networks";
        };

      };

      config = lib.mkIf cfg.enable {
        networking.nameservers = [ "::1" ];
        services = {
          resolved.enable = lib.mkForce false;
          dnsdist = {
            enable = true;
            extraConfig = ''
              addLocal("[::]:53")

              local nat64nets = newNMG()
              ${lib.concatStringsSep "\n" (map (net: ''nat64nets:addMask("${net}")'') cfg.nat64Networks)}

              -- backends
              newServer({
                address = "${cfg.backend64}",
                pool = "dns64"
              })

              newServer({
                address = "${cfg.backend}",
                pool = "default"
              })

              -- access-rules
              ${lib.concatStringsSep "\n" (map (net: ''addACL("${net}")'') cfg.acl)}

              addAction(
                NetmaskGroupRule(nat64nets),
                PoolAction("dns64")
              )

              addAction(
                AllRule(),
                PoolAction("default")
              )
            '';
          };
        };

        networking.firewall = lib.mkIf cfg.openFirewall {
          allowedTCPPorts = [ 53 ];
          allowedUDPPorts = [ 53 ];
        };

      };

    };
}
