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
  };

  hroffice = {
    hostName = "hroffice";
    domain = infra_domain;

  };

  hrserver = {
    hostName = "hrserver";
    domain = infra_domain;
  };
}
