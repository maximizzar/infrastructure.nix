# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
let
  service_domain = "services.genesis.maximizzar.org";
  infra_domain = "infra.genesis.maximizzar.org";
in
{
  gw = {
    hostName = "gw-genesis";
    domain = infra_domain;

    MACAddress = "02:4e:9f:83:50:a9";
    Ipv4Address = "192.168.178.109";
    Ipv6Address = "fd80:3aa8:691a:ff03:4e:9fff:fe83:50a9";

    bridges = {
      exec = {
        MACAddress = "02:5f:d1:df:7e:93";
        Ipv6Address = "fd80:3aa8:691a:ff00:5f:d1ff:fedf:7e93";
      };

      dmz = {
        MACAddress = "02:54:29:6b:25:19";
        Ipv6Address = "fd80:3aa8:691a:ff01:54:29ff:fe6b:2519";
      };

      srv = {
        MACAddress = "02:39:18:6e:9f:e8";
        Ipv6Address = "fd80:3aa8:691a:ff02:39:18ff:fe6e:9fe8";
      };
    };

    network = "srv";
  };

  mip3 = {
    hostName = "mip3";
    domain = infra_domain;

    network = "lan";
  };

  workstation = {
    hostName = "workstation";
    domain = "workstation";

    Ipv4Address = "";
    Ipv6Address = "";

    network = "lan";
  };

  auth = {
    hostName = "auth";
    domain = service_domain;

    MACAddress = "02:4d:b1:4b:74:4a";
    Ipv4Address = "";
    Ipv6Address = "fd80:3aa8:691a:ff02:4d:b1ff:fe4b:744a";

    network = "srv";
  };

  factorio = {
    hostName = "factorio";
    domain = service_domain;

    MACAddress = "02:b6:8f:5c:60:a8";
    Ipv4Address = "";
    Ipv6Address = "fd80:3aa8:691a:ff01:b6:8fff:fe5c:60a8";

    network = "dmz";
  };

  forgejo = {
    hostName = "forgejo";
    domain = service_domain;

    MACAddress = "02:c1:fa:65:d8:1e";
    Ipv6Address = "fd80:3aa8:691a:ff02:c1:faff:fe65:d81e";

    network = "srv";
  };

  monitoring = {
    hostName = "monitoring";
    domain = service_domain;

    MACAddress = "02:7f:b7:59:d0:7a";
    Ipv6Address = "fd80:3aa8:691a:ff02:7f:b7ff:fe59:d07a";

    network = "srv";
  };

  runner = {
    hostName = "runner";
    domain = service_domain;

    MACAddress = "02:b9:79:5d:ab:82";
    Ipv6Address = "fd80:3aa8:691a:ff00:b9:79ff:fe5d:ab82";

    network = "runner";
  };

  navidrome = {
    hostName = "navidrome";
    domain = service_domain;

    MACAddress = "02:9d:b3:6c:ef:e1";
    Ipv6Address = "fd80:3aa8:691a:ff02:9d:b3ff:fe6c:efe1";

    network = "srv";
  };

  opencloud = {
    hostName = "opencloud";
    domain = service_domain;

    MACAddress = "02:96:C0:45:32:46";
    Ipv4Address = "";
    Ipv6Address = "fd80:3aa8:691a:ff02:96:c0ff:fe45:3246";

    network = "srv";
  };

  resolver = {
    hostName = "resolver";
    domain = service_domain;

    MACAddress = "02:4b:64:2d:81:69";
    Ipv4Address = "";
    Ipv6Address = "fd80:3aa8:691a:ff02:4b:64ff:fe2d:8169";

    containers = {
      nameserver = {
        hostName = "nameserver";
        domain = "${service_domain}";

        MACAddress = "02:38:58:c6:d3:83";
        Ipv6Address = "fd80:3aa8:691a:ff02:38:58ff:fec6:d383";
      };
      resolver64 = {
        hostName = "resolver64";
        domain = "${service_domain}";

        MACAddress = "02:14:76:46:14:82";
        Ipv6Address = "fd80:3aa8:691a:ff02:14:76ff:fe46:1482";
      };
    };

    network = "srv";
  };

}
