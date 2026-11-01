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
        ./_settings.nix
      ];
      options.maximizzar.authServer = {
        enable = lib.mkEnableOption "Enable Auth Server for domain";
        openFirewall = lib.mkEnableOption "";

        hostName = lib.mkOption {
          type = lib.types.str;
          default = "auth";
        };
        domain = lib.mkOption {
          type = lib.types.str;
          default = "maximizzar.org";
        };
        fqdn = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.hostName}.${cfg.domain}";
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
        services.authelia.instances."${cfg.domain}" = {
          enable = true;
        };
      };

    };
}
