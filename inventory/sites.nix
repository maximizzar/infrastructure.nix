# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  overlay.Prefix = "fd80:3aa8:691a::/48";
  transit = {
    Prefix = "fd95:948f:5cae::/64";
    peers = {
      genesis = {
        address = "fd95:948f:5cae::1/128";
        publicKey = "7Uj9ff/olpiC3HbU+/6lRADIy1jjgrDoCWqw8DqqBxU=";
      };

      nbg = {
        address = "fd95:948f:5cae::2/128";
        publicKey = "M5D6n6anAAnLazg1uSv9yst7F2hdkdbGadcAsCm/KhM=";
      };

      ext1 = {
        address = "fd95:948f:5cae::3/128";
        publicKey = "O7sIQMesW+B2Y+8felV6FooQzBFtUlpzQlyEah8BWzU=";
      };

    };
  };

  genesis = {
    Domain = "genesis.prod.maximizzar.org";
    Prefix = "fd80:3aa8:691a:ff00::/56";

    networks = {
      gwbr = {
        Name = "Containers on the gateway";
        Prefix = "fd80:3aa8:691a:ff00::/64";
      };

      dmz = {
        Name = "Machines with public ips";
        Prefix = "fd80:3aa8:691a:ff01::/64";
      };

      srv = {
        Name = "Machines without public ips";
        Prefix = "fd80:3aa8:691a:ff02::/64";
      };

      lan = {
        Name = "LAN for client PCs";
        Prefix = "fd80:3aa8:691a:ff03::/64";
      };

      ns = {
        Name = "Subnet for nameservers";
        Prefix = "fd80:3aa8:691a:ff53::/64";
      };

    };

    hosts = {
      forgejo = { };

      gw = {
        interfaces = {
          br-container = {
            mac = "02:4e:9f:83:50:a9";
            address = "fd80:3aa8:691a:ff00:4e:9fff:fe83:50a9";
          };

          ens18 = {
            mac = "bc:24:11:ad:cb:a6";
          };

          ens19 = {
            mac = "bc:24:11:03:5f:5d";
            address = "fd80:3aa8:691a:ff01:be24:11ff:feee:cfc8";
            fqdn = "gw.dmz.genesis.prod.maximizzar.org";
          };

          ens20 = {
            mac = "bc:24:11:be:01:cf";
            address = "fd80:3aa8:691a:ff02:be24:11ff:febe:1cf";
            fqdn = "gw.srv.genesis.prod.maximizzar.org";
          };

          wg0 = {

          };

        };
      };

      prometheus = {
        interfaces = {
          ens18 = {
            mac = "bc:24:11:bb:28:39";
            address = "fd80:3aa8:691a:ff02:be24:11ff:febb:2839";
            fqdn = "prometheus.srv.genesis.prod.maximizzar.org";
          };

        };
      };

      resolver = {
        interfaces = {
          br-container = {
            mac = "02:4b:64:2d:81:69";
          };

          ens18 = {
            mac = "bc:24:11:49:25:c8";
          };

        };

      };
      runner = { };
      vaultwarden = { };
    };

  };

  nbg = {
    Domain = "nbg.prod.maximizzar.org";
    Prefix = "fd80:3aa8:691a:fe00::/56";

    networks = {
      dmz = {
        Name = "Machines with public ips";
        Prefix = "fd80:3aa8:691a:fe00::/64";
      };

    };
  };

  ext1 = {
    Domain = "prod.maximizzar.org";
    Prefix = "fd80:3aa8:691a:fd00::/56";

    networks = {
      lan = {
        Name = "LAN Prefix";
        Prefix = "fd80:3aa8:691a:fd00::/64";
      };

    };
  };

}
