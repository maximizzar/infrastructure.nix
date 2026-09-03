# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.services.forgejo;
in
{
  config = lib.mkIf cfg.enable {
    services.forgejo.dump = {
      enable = true;

      age = "5d";
      type = "tar.xz";
      interval = "19:00";
    };

    services.forgejo.database = {
      passwordFile = cfg.passwordFile;
      socket = "/run/postgresql";
      type = "postgres";
    };

    services.postgresql.enable = true;
    services.postgresql = {
      ensureUsers = [
        {
          name = config.services.forgejo.user;
          ensureDBOwnership = true;
        }
      ];

      ensureDatabases = [
        config.services.forgejo.database.name
      ];

    };

  };
}
