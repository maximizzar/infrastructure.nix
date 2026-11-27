# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.services = {
    services.aria2 = {
      settings.enable-rpc = true;
      openPorts = true;
      serviceUMask = "0002";
    };
  };
}
