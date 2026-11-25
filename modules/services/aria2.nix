# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  service = "services-aria2";
in
{
  flake.nixosModules."${service}".services."${service}" = {
    enable = true;
    settings = {
      enable-rpc = true;
    };
    openPorts = true;
    serviceUMask = "0002";
  };
}
