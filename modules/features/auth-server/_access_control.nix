# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, ... }:
let
  cfg = config.maximizzar.authServer;
in
{
  services.authelia.instances."${cfg.domain}" = {
    settings.access_control = {
      default_policy = "deny";
      rules = [
        {
          domain = "auth.maximizzar.org";
          policy = "bypass";
        }
      ];
    };
  };
}
