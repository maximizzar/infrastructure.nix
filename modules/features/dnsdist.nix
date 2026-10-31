# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }:
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
          type = lib.types.str;
        };

      };

      config = lib.mkIf cfg.enable {
        services = {
          resolved.enable = lib.mkForce false;
          dnsdist = {
            enable = true;
            listenAddress = "[::]";
            extraConfig = ''
              -- Backend-Server
              newServer({address="${cfg.backend}"})

              -- access rules
              setACL({"${cfg.acl}"})
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
