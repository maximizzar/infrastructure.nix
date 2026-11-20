# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, ... }:
let
  cfg = config.maximizzar.vpn;
in
{
  networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
}
