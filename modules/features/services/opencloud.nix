# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, ... }: {
  flake.nixosModules.opencloud =
    { config, lib, ... }:
    let
      cfg = config.maximizzar.opencloud;
      modules = with self.nixosModules; [ acmeService ];
    in
    {
      imports = modules;
      options.maximizzar.opencloud = {
        enable = lib.mkEnableOption "";
        openFirewall = lib.mkEnableOption "";

        environmentFile = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };

        url = lib.mkOption {
          type = lib.types.str;
          default = "https://${cfg.subdomain}.${cfg.domain}";
        };

        subdomain = lib.mkOption {
          type = lib.types.str;
          default = config.networking.hostName;
        };

        domain = lib.mkOption {
          type = lib.types.str;
          default = "maximizzar.org";
        };
      };

      config = lib.mkIf cfg.enable {
        maximizzar.acmeService = {
          group = config.services.opencloud.group;
        };

        services.opencloud = {
          inherit (cfg) enable environmentFile url;
          address = "[::]";
          environment = { };
          settings = {
            loglevel = "warn";

            http = {
              # lib/acme/opencloud.services.genesis.maximizzar.org
              tls_cert = "/var/lib/acme/${config.networking.fqdn}/fullchain.pem";
              tls_key = "/var/lib/acme/${config.networking.fqdn}/key.pem";
              tls = true;
            };
          };
        };

        networking.firewall = lib.mkIf cfg.openFirewall {
          allowedTCPPorts = [ config.services.opencloud.port ];
          allowedUDPPorts = [ config.services.opencloud.port ];
        };
      };
    };
}
