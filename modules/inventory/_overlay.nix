# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  Prefix = "fd80:3aa8:691a::/48";
  sites = {
    genesis = {
      Domain = "genesis.prod.maximizzar.org";
      Prefix = "fd80:3aa8:691a:ff00::/56";

      networks = {
        gwbr = {
          Name = "Containers on the gateway";
          Prefix = "fd80:3aa8:691a:ff00::/64";
        };

        dmz = {
          Name = "Machines directly exposed";
          Prefix = "fd80:3aa8:691a:ff01::/64";
        };

        srv = {
          Name = "Machines behind a proxy";
          Prefix = "fd80:3aa8:691a:ff02::/64";
        };

        lan = {
          Name = "LAN for client PCs";
          Prefix = "fd80:3aa8:691a:ff03::/64";
        };

      };

      hosts = import ./hosts/_genesis-hosts.nix;
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

      hosts = import ./hosts/_nbg-hosts.nix;
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

      hosts = import ./hosts/_ext1-hosts.nix;
    };

  };
}
