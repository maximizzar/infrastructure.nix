# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.services.forgejo;

  basedomain = "maximizzar.org";
  fqdn = "forgejo.srv.genesis.prod.${basedomain}";
in
{
  config = lib.mkIf cfg.enable {
    security.acme.certs."${fqdn}" = {
      domain = fqdn;
      webroot = "/var/lib/acme/acme-challenge";
      postRun = "systemctl reload nginx";
    };

  };
}
