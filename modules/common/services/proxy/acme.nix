# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  config,
  lib,
  ...
}:
let
  cfg = config.maximizzar.modules.services.proxy;
in
{
  config = lib.mkIf cfg.enable {
    security.acme.certs."maximizzar.org" = {
      dnsProvider = "ionos";
      environmentFile = cfg.environmentFile;
      dnsResolver = "[2620:fe::fe]:53";
      dnsPropagationCheck = false;

      domain = "maximizzar.org";
      extraDomainNames = [ "*.maximizzar.org" ];

      group = config.services.nginx.group;

      email = "mail@maximizzar.de";
      server = "https://acme-v02.api.letsencrypt.org/directory";
    };
  };
}
