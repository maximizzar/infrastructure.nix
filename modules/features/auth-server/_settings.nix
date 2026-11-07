# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.authServer;
in
{
  config = lib.mkIf cfg.enable {
    services.authelia.instances."${cfg.domain}" = {
      settings = {
        default_2fa_method = "totp";

        log = {
          format = "json";
          level = "info";
        };

        telemetry.metrics.enabled = true;
        theme = "grey";

        authentication_backend.file.path = cfg.usersDatabase;
        storage.local.path = "/var/lib/authelia-${cfg.domain}/db.sqlite3";
        notifier.filesystem.filename = "/var/lib/authelia-${cfg.domain}/notification.txt";
      };
    };

  };
}
