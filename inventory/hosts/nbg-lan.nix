{
  gw = {
    name = "gw.nbg";
    fqdn = "gw.nbg.maximizzar.org";

    ip = "fd80:3aa8:691a:101::1";
    ip6-arpa = "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1.0.1.0";
  };

  proxy = {
    name = "proxy.nbg";
    fqdn = "proxy.nbg.maximizzar.org";

    ip = "fd80:3aa8:691a:101::80:443";
    ip6-arpa = "3.4.4.0.0.8.0.0.0.0.0.0.0.0.0.0.1.0.1.0";
  };

  static = {
    name = "static.nbg";
    fqdn = "static.nbg.maximizzar.org";

    ip = "fd80:3aa8:691a:101::80";
    ip6-arpa = "0.8.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1.0.1.0";
  };
}