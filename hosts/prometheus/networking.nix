# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  inventory,
  ...
}:
let
  site = inventory.sites.genesis;
  wan_interface = "ens18";
in
{
  networking = {
    hostName = "prometheus";
  };
  maximizzar.networking.vmNetworking.enable = true;

}
