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

    containers = {
      pforgejo = {
        hostName = "proxy-forgejo";
        domain = "${service_domain}";

        MACAddress = "02:37:9a:cc:7d:99";
        Ipv6Address = "fd80:3aa8:691a:fe00:37:9aff:fecc:7d99";
      };
    };

  };
}
