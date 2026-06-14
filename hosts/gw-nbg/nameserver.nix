{ pkgs, inventory, ... }:
let
  hosts = inventory.sites.nbg.router.interfaces.lan.hosts;
in
{
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.bind = {
    enable = true;

    zones."maximizzar.org" = {
      master = true;
      file = pkgs.writeText "zone-maximizzar.org" ''
        $ORIGIN maximizzar.org.
        $TTL 300

        @ IN SOA ${hosts.ns1.fqdn}. hostmaster.maximizzar.org. ( 1 3h 1h 1w 1h )

        @ IN NS ${hosts.ns1.name}

        @ IN A 178.105.53.186
        @ IN AAAA 2a01:4f8:c2c:bd86::1

        ; NS Delegation
        genesis.maximizzar.org. NS ${inventory.sites.genesis.router.interfaces.lan.hosts.ns1.name}
        genesis.maximizzar.org. AAAA ${inventory.sites.genesis.router.interfaces.lan.hosts.ns1.ip}

        ; CNAME
        static IN CNAME ${hosts.proxy.name}

        ; AAAA
        ${hosts.gw.name} IN AAAA ${hosts.gw.ip}

        ${hosts.ns1.name} IN AAAA ${hosts.ns1.ip}
        ${hosts.proxy.name} IN AAAA ${hosts.proxy.ip}
      '';
    };
  };

  services.bind.cacheNetworks = [
  "127.0.0.0/8"
  "::1/128"

  "${inventory.networks.overlay.cidr}"
  ];

  services.bind.extraOptions = ''
    recursion no;

    allow-query { any; };

    allow-recursion {
      ${inventory.networks.overlay.cidr};
      localhost;
    };
  '';
}