# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.dnsdist =
    {
      config,
      lib,
      ...
    }:
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

              -- Backend-Server
              newServer({address="${cfg.backend}"})

              -- access rules
              ${lib.concatStringsSep "\n" (map (net: ''addACL("${net}")'') cfg.acl)}
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
