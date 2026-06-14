{
  gw = {
    name = "gw.lan.nbg";
    fqdn = "gw.lan.nbg.maximizzar.org";

    ip = "fd80:3aa8:691a:101::1";
    ip6-arpa = "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0";
  };

  ns1 = {
    name = "ns1.lan.nbg";
    fqdn = "ns1.lan.nbg.maximizzar.org";

    ip = "fd80:3aa8:691a:101::53";
    ip6-arpa = "3.5.0.0.0.0.0.0.0.0.0.0.0.0.0.0";
  };

  proxy = {
    name = "proxy.lan.nbg";
    fqdn = "proxy.lan.nbg.maximizzar.org";

    ip = "fd80:3aa8:691a:101::80:443";
    ip6-arpa = "3.4.4.0.0.8.0.0.0.0.0.0.0.0.0.0";
  };
}
