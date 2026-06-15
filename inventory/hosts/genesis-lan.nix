# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  gw = {
    name = "gw.genesis";
    fqdn = "gw.genesis.maximizzar.org";

    ip = "fd80:3aa8:691a:201::1";
    ip6-arpa = "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0";
  };

  proxy = {
    name = "proxy.genesis";
    fqdn = "proxy.genesis.maximizzar.org";

    ip = "fd80:3aa8:691a:201::80:443";
    ip6-arpa = "3.4.4.0.0.8.0.0.0.0.0.0.0.0.0.0";
  };

  navidrome = {
    name = "navidrome.genesis";
    fqdn = "navidrome.genesis.maximizzar.org";

    ip = "fd80:3aa8:691a:201::8080:1";
    ip6-arpa = "1.0.0.0.0.8.0.8.0.0.0.0.0.0.0.0.1.0.2.0";
  };
  jellyfin = {
    name = "jellyfin.genesis";
    fqdn = "jellyfin.genesis.maximizzar.org";

    ip = "fd80:3aa8:691a:201::8080:2";
    ip6-arpa = "2.0.0.0.0.8.0.8.0.0.0.0.0.0.0.0.1.0.2.0";
  };
  static = {
    name = "static.genesis";
    fqdn = "static.genesis.maximizzar.org";

    ip = "fd80:3aa8:691a:201::8080:3";
    ip6-arpa = "3.0.0.0.0.8.0.8.0.0.0.0.0.0.0.0.1.0.2.0";
  };
}
