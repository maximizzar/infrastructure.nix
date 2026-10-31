# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  service_domain = "services.hr.maximizzar.org";
  infra_domain = "infra.hr.maximizzar.org";
in
{
  hrattic = {
    hostName = "hrattic";
    domain = infra_domain;

    Ipv6Address = "fe80::1";
  };

  hroffice = {
    hostName = "hroffice";
    domain = infra_domain;

    Ipv6Address = "fe80::1";
  };

  hrserver = {
    hostName = "hrserver";
    domain = infra_domain;

    Ipv6Address = "fe80::1";
  };
}
