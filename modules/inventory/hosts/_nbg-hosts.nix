# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  service_domain = "services.nbg.maximizzar.org";
  infra_domain = "infra.nbg.maximizzar.org";
in
{
  gw = {
    hostName = "gw-nbg";
    domain = infra_domain;

    MACAddress = "02:a2:57:a0:dd:70";
    Ipv4Address = "178.105.53.186";
    Ipv6Address = "2a01:4f8:c2c:bd86:a2:57ff:fea0:dd70";
  };
}
