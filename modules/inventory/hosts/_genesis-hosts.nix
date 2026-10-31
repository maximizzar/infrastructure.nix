# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  service_domain = "opencloud.services.genesis.maximizzar.org";
in
{
  opencloud = {
    hostName = "opencloud";
    domain = "${service_domain}";

    MACAddress = "02:96:C0:45:32:46";
    Ipv4Address = "";
    Ipv6Address = "fd80:3aa8:691a:ff02:96:c0ff:fe45:3246";

    network = "srv";
  };

  resolver = {
    hostName = "resolver";
    domain = "services.genesis.maximizzar.org";

    MACAddress = "02:4b:64:2d:81:69";
    Ipv4Address = "192.168.178.253";
    Ipv6Address = "fd80:3aa8:691a:ff02:4b:64ff:fe2d:8169";

    containers = {
      nameserver = {
        hostName = "nameserver";
        domain = "${service_domain}";

        MACAddress = "02:38:58:c6:d3:83";
        Ipv4Address = "192.168.178.252";
        Ipv6Address = "fd80:3aa8:691a:ff02:38:58ff:fec6:d383";
      };
    };

    network = "dmz";
  };

}
