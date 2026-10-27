# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.services.authelia;
in
{
  config = lib.mkIf cfg.enable {
    services.authelia.instances."maximizzar.org" = {
      settings = {
        default_2fa_method = "totp";

        log = {
          format = "json";
          level = "info";
        };

        telemetry.metrics.enabled = true;
        theme = "grey";

        authentication_backend.file.path = cfg.usersDatabase;
        storage.local.path = "/var/lib/authelia-maximizzar.org/db.sqlite3";
        notifier.filesystem.filename = "/var/lib/authelia-maximizzar.org/notification.txt";
      };
    };

  };
}
