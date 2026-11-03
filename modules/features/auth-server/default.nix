# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.authServer =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.maximizzar.authServer;
    in
    {
      imports = [
        ./_clients
        ./_access_control.nix
        ./_cookies.nix
        ./_secrets.nix
        ./_settings.nix
      ];

      options.maximizzar.authServer = {
        enable = lib.mkEnableOption "Enable Auth Server for domain";
        openFirewall = lib.mkEnableOption "Open Authelia port 9091";
        port = lib.mkOption {
          default = 9091;
          type = lib.types.int;
        };

        hostName = lib.mkOption {
          type = lib.types.str;
          default = config.networking.hostName;
        };
        domain = lib.mkOption {
          type = lib.types.str;
          default = "maximizzar.org";
        };
        fqdn = lib.mkOption {
          type = lib.types.str;
          default = config.networking.fqdn;
        };

        jwtSecretFile = lib.mkOption {
          type = lib.types.str;
        };

        oidcHmacSecretFile = lib.mkOption {
          type = lib.types.str;
        };

        oidcIssuerPrivateKeyFile = lib.mkOption {
          type = lib.types.str;
        };

        sessionSecretFile = lib.mkOption {
          type = lib.types.str;
        };

        storageEncryptionKeyFile = lib.mkOption {
          type = lib.types.str;
        };

        usersDatabase = lib.mkOption {
          type = lib.types.str;
        };

      };

      config = lib.mkIf cfg.enable {
        networking.firewall = lib.mkIf cfg.openFirewall {
          allowedTCPPorts = [ cfg.port ];
          allowedUDPPorts = [ cfg.port ];
        };

        security.acme.certs."${cfg.fqdn}" = {
          domain = cfg.fqdn;
          webroot = "/var/lib/acme/acme-challenge";
          group = "authelia-maximizzar.org";
          postRun = "systemctl reload authelia-maximizzar.org";
        };

        services.authelia.instances."${cfg.domain}" = {
          inherit (cfg) enable;

          settings.server = {
            address = "tcp://[::]:${toString cfg.port}";
            tls = {
              certificate = "/var/lib/acme/${cfg.fqdn}/fullchain.pem";
              key = "/var/lib/acme/${cfg.fqdn}/key.pem";
            };
          };

        };

      };

    };
}
