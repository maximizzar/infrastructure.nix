{ pkgs, ... }: {
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
  services.bind = {
    enable = true;
  };

  services.bind.zones."maximizzar.org" = {
    master = true;
    file = pkgs.writeText "zone-maximizzar.org" ''
      $ORIGIN maximizzar.org.
      $TTL 300

      @ IN SOA ns1.maximizzar.org. hostmaster.maximizzar.org. ( 2 3h 1h 1w 1h )
      @ IN NS ns1

      ns1 IN AAAA fd19:38bc:a21d:1abf:52e5:75ff:fe61:13c7
    '';
  };
}
