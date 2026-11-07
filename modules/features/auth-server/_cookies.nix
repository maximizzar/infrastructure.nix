# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, ... }:
let
  cfg = config.maximizzar.authServer;
in
{
  services.authelia.instances."${cfg.domain}" = {
    settings.session.cookies = [
      {
        domain = cfg.domain;
        authelia_url = "https://auth.maximizzar.org";
        default_redirection_url = "https://${cfg.domain}";
      }
    ];
  };
}
