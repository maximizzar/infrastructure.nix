{
  gw = {
    name = "gw.lan";
    fqdn = "gw.lan.genesis.maximizzar.org";

    ip = "fd80:3aa8:691a:201::1";
    ip6-arpa = "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0";
  };

  ns1 = {
    name = "ns1.lan";
    fqdn = "ns1.lan.genesis.maximizzar.org";

    ip = "fd80:3aa8:691a:201::53";
    ip6-arpa = "3.5.0.0.0.0.0.0.0.0.0.0.0.0.0.0";
  };

  proxy = {
    name = "proxy.lan";
    fqdn = "proxy.lan.genesis.maximizzar.org";

    ip = "fd80:3aa8:691a:201::80:443";
    ip6-arpa = "3.4.4.0.0.8.0.0.0.0.0.0.0.0.0.0";
  };
}
