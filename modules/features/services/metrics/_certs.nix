# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.metrics;
in
{
  config = lib.mkIf cfg.enable {
    security.acme.certs."${cfg.domain}" = {
      inherit (cfg) domain;
      webroot = "/var/lib/acme/acme-challenge";
      reloadServices = [ "nginx" ];
    };
  };
}
