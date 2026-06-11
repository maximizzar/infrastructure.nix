{
  overlay.cidr = "fd80:3aa8:691a:;/48";
  transit.cidr = "fd95:948f:5cae::/64";

  networks = import ./networks.nix;
  sites = import ./sites.nix;
}
